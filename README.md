# TurtleHCFilter
Filter the HC chan messages and redirect them to a chatframe of choice

Usage:

Show HCF settings
```
/hcf info
```

Move Hardcore chat to Chat frame #3  (pick number 1-9)
```
/hcf 3
```
or
```
/hcf frame 3
```

Change Hardcore chat prefix to H (default HC)
```
/hcf prefix H
```

Remove Hardcore chat prefix
```
/hcf prefix
```

Set Hardcore chat prefix back to Hardcore
```
/hcf prefix Hardcore
```

Set Hardcore chat colour
**Must be a hex code**
```
/hcf colour e6cd80
```

Set Hardcore chat colour back to default
```
/hcf colour
```

Enable or disable the WTS ##+ level filtering feature
_note: Due to server restrictions, the level of the sender cannot be queried so the standard format `WTS [Broad Claymore] 15+-` is used for filtering purposes_
```
/hcf levelfilter
```

Enable or disable debug mode (useful to detect if the level filtering is behaving properly)
```
/hcf debug
```
