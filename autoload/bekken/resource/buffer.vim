vim9script

import autoload "bekken.vim" as b

const defaultKeyMappings: dict<func(number): void> = {
  "\<Cr>": (bufnr: number) => {
    execute("buffer " .. bufnr)
  },
  "\<Tab>": (bufnr: number) => {
    execute("tab split | buffer " .. bufnr)
  },
  "\<C-t>": (bufnr: number) => {
    execute("tab split | buffer " .. bufnr)
  },
  "\<C-s>": (bufnr: number) => {
    execute("split | buffer " .. bufnr)
  },
  "\<C-v>": (bufnr: number) => {
    execute("vsplit | buffer " .. bufnr)
  },
}

var keyMappings: dict<func> = {}

export def FilterKey(): string
  return "search"
enddef

export def List(...args: list<any>): list<dict<any>>
  var includes_hidden: bool = args->len() > 0 ? !!args[0] : false

  keyMappings->extend(copy(defaultKeyMappings))
  if args->len() > 1
    keyMappings->extend(copy(args[1]))
  endif

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
  if keyMappings->has_key(key)
    const selected = bekken.GetResource().selected

    if selected != null
      keyMappings[key](selected.buffer.bufnr)
    endif

    bekken.Close()
  endif

  return true
enddef
