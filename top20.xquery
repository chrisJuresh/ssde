xquery version "3.1";

declare variable $files := collection("./files/?select=*xml");

<results>
  <table>
    <tr>
      <th>Target</th>
      <th>Successor</th>
      <th>Probability</th>
    </tr>
    {
      let $has_pairs := 
        for $sentence in $files//s
        for $word at $position in $sentence/w
        where lower-case(normalize-space($word)) = "has"
        let $successor := normalize-space($sentence/w[$position + 1])
        return if ($successor) then concat(normalize-space($word), ' ', $successor) else ()
      
      let $sorted_pairs := 
        for $pair in distinct-values($has_pairs)
        let $target := substring-before($pair, ' ')
        let $successor := substring-after($pair, ' ')
        let $occurrences_with_target := count($has_pairs[. = $pair])
        let $total_occurrences := count($files//w[normalize-space(.) = $successor])
        let $probability := $occurrences_with_target div $total_occurrences
        order by $probability descending
        return <pair>{$pair}</pair>
      
      for $pair in $sorted_pairs[position() <= 20]
      let $target := substring-before($pair, ' ')
      let $successor := substring-after($pair, ' ')
      let $probability := count($has_pairs[. = $pair]) div count($files//w[normalize-space(.) = $successor])
      return
        <tr>
          <td>{$target}</td>
          <td>{$successor}</td>
          <td>{format-number($probability, '0.##')}</td>
        </tr>
    }
  </table>
</results>
