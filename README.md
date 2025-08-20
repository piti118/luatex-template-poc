# TGTex

Json to Latex to PDF template engine. Based on modified version of [lustache](https://github.com/Olivine-Labs/lustache) to make it a bit more tex friendly (change tag + escape annoying tex character instead of html).

# Usage

See main.tex and example.json for an example of how to use it. But, in a nutshell:

```latex
% Lua code to read JSON, use etlua template, and output a table

\begin{luacode*}
local t = require "tgtex.lua"
local json = t.readJSON("example.json")
local template_content = t.readFile("template.tex")

for i, entry in ipairs(json.data) do
  local output = t.renderTemplate(template_content, entry)
  t.printTEX(output)
end
\end{luacode*}
```
then compile it with lualatex

```
lualatex main.tex
```

# Basic Usage

See `template.tex` for the structure of the template.

## Output a Text

```
<<variable_name>>
```

## Section

Section can be used for both forloop and filter

### forloop
Ex: if `pets` field is an array, you can do the following:

```
<<#pets>>
<<name>>
<</pets>>
```

This is roughly equivalent to:

```lua
for i, pet in ipairs(pets) do
  print(pet.name)
end
```

### Filter/Formatting

Sometime we need to format the output, ex putting comma, doing date or datetime format.
If the section name is a function field. (We have already enrich your context with some formatting function)

```
<<#comma>><<number>><</comma>>
```

this is roughly equivalent to:

```lua
print(t.comma(number))
```

we have date formatting as well:

```
<<#date>><<date>><</date>>
```

and datetime formatting:

```
<<#datetime>><<datetime>><</datetime>>
```