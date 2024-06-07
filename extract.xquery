xquery version "3.1";

declare variable $files := collection("./files/?select=*xml");

<results>
  <table>
    <tr>
      <th>Target</th>
      <th>Successor</th>
    </tr>
    {
      for $sentence in $files//s
      for $word at $position in $sentence/w
      where lower-case(normalize-space($word)) = "has"
      let $successor := $sentence/w[$position + 1]
      return
        if ($successor)
        then
          <tr>
            <td>{normalize-space($word)}</td>
            <td>{normalize-space($successor)}</td>
          </tr>
        else ()
    }
  </table>
</results>
