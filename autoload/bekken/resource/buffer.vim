vim9script

import autoload "bekken.vim" as b

const keyMapping = {
  "\<Cr>": "buffer",
  "\<Tab>": "tab split | buffer",
  "\<C-t>": "tab split | buffer",
  "\<C-s>": "split | buffer",
  "\<C-v>": "vsplit | buffer",
}

export def FilterKey(): string
  return "search"
enddef

export def List(...args: list<any>): list<dict<any>>
  var includes_hidden: bool = args->len() > 0 ? !!args[0] : false

  return copy(getbufinfo())
    ->filter((key, val) => includes_hidden ? true : val.listed)
    ->map((key, val) => ({
      search: [
        val.bufnr,
        fnamemodify(val.name, ":t") == "" ? "[No Name]" : val.name,
      ]->join(" "),
      line: [
        printf("% 6d", val.bufnr),
        (val.changed ? "+" : (val.bufnr == bufnr() ? "%" : " ")),
        printf("%-60S", (fnamemodify(val.name, ":t") == "" ? "[No Name]" : fnamemodify(val.name, ":t"))),
        fnamemodify(val.name, ":~:h"),
      ]->join(" "),
      buffer: val
    }))
enddef

export def Render(line: number, target: dict<any>, bekken: b.Bekken): string
  return target.line
enddef

export def Filter(key: string, bekken: b.Bekken): bool
  if keyMapping->has_key(key)
    const selected = bekken.GetResource().selected

    if selected != null
      execute(keyMapping[key] .. " " .. selected.buffer.bufnr)
    endif

    bekken.Close()
  endif

  return true
enddef
