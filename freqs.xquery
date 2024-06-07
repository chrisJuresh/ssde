xquery version "3.1";

declare variable $files := collection("./files/?select=*xml");

<results>
  <table>
    <tr>
      <th>Target</th>
      <th>Successor</th>
      <th>Frequency</th>
    </tr>
    {
      let $has_pairs := 
        for $sentence in $files//s
        for $word at $position in $sentence/w
        where lower-case(normalize-space($word)) = "has"
        let $successor := normalize-space($sentence/w[$position + 1])
        return if ($successor) then concat(normalize-space($word), ' ', $successor) else ()
      
      for $pair in distinct-values($has_pairs)
      let $frequency := count($has_pairs[. = $pair])
      order by $frequency descending
      return
        <tr>
          <td>{substring-before($pair, ' ')}</td>
          <td>{substring-after($pair, ' ')}</td>
          <td>{$frequency}</td>
        </tr>
    }
  </table>
</results>
