#!/bin/sh
# waybar custom/cpu: uso total + tooltip tipo tarjeta separando P-cores de E-cores.
# Topologia: cada linea es un core fisico con sus hilos, "0,1" (P, con SMT) o "16" (E).
topo=${XDG_RUNTIME_DIR:-/tmp}/waybar-cpu-topology
[ -s "$topo" ] || for n in $(seq 0 $(( $(nproc) - 1 ))); do
  tr - , < "/sys/devices/system/cpu/cpu$n/topology/thread_siblings_list"
done | awk '!seen[$0]++' | tr '\n' ' ' > "$topo"
cores=$(cat "$topo")

# colores de pywal: texto, apagado y acento
w=$HOME/.cache/wal/colors
c7=$(sed -n 8p "$w" 2>/dev/null)
c8=$(sed -n 9p "$w" 2>/dev/null)
c9=$(sed -n 10p "$w" 2>/dev/null)

a=$(grep '^cpu' /proc/stat)
sleep 0.5
b=$(grep '^cpu' /proc/stat)

printf '%s\n---\n%s\n' "$a" "$b" | awk -v cores="$cores" \
                                       -v c7="$c7" -v c8="$c8" -v c9="$c9" '
/^---$/ { second = 1; next }
{
  idle = $5 + $6
  total = 0
  for (i = 2; i <= NF; i++) total += $i
  if (!second) { pi[$1] = idle; pt[$1] = total; next }
  d = total - pt[$1]
  di = idle - pi[$1]
  u[$1] = (d > 0) ? 100 * (d - di) / d : 0
}
function hex(s, i) { return strtonum("0x" substr(s, i, 2)) }
function shade(c, hot,   k) {         # apagado -> acento segun la carga
  if (hot && c >= 90) return "#dc4646"
  k = 0.25 + 0.75 * c / 100
  return sprintf("#%02x%02x%02x", hex(c8,2) + (hex(c9,2) - hex(c8,2)) * k,
                                  hex(c8,4) + (hex(c9,4) - hex(c8,4)) * k,
                                  hex(c8,6) + (hex(c9,6) - hex(c8,6)) * k)
}
function span(col, txt) { return "<span color=\047" col "\047>" txt "</span>" }
function hbar(c,   n, i, fill, rest) {     # barra + porcentaje a la derecha
  n = int(c * BW / 100 + 0.5)
  if (n > BW) n = BW
  for (i = 0; i < BW; i++) { if (i < n) fill = fill " "; else rest = rest "░" }
  return "<span bgcolor=\047" shade(c, 1) "\047>" fill "</span>" span(c8, rest) \
         "  " span(shade(c, 1), sprintf("%3d%%", c))
}
function section(icon, label, note, pct, bars) {
  return " " span(c9, icon) "  <b>" label "</b>   " span(c8, note) "\\n" \
         " " hbar(pct) "\\n" \
         " " bars
}
BEGIN {
  BW = 22
  split("▁ ▂ ▃ ▄ ▅ ▆ ▇ █", B, " ")
  if (c7 == "") c7 = "#b1c8d9"
  if (c8 == "") c8 = "#2a3a48"
  if (c9 == "") c9 = "#2b92e7"
}
END {
  n = split(cores, core, " ")
  for (i = 1; i <= n; i++) {
    t = split(core[i], th, ",")
    sum = 0
    for (j = 1; j <= t; j++) {
      c = u["cpu" th[j]]
      sum += c
      lvl = int(c / 12.5) + 1
      if (lvl > 8) lvl = 8
      s = s span(shade(c, 0), B[lvl])
    }
    if (t > 1) { p = p s " "; psum += sum; pn += t; pcores++ }   # P-core: hilos pegados
    else       { e = e s " "; esum += sum; en++                  # E-core: en grupos de 4
                 if (en % 4 == 0) e = e "  " }
    s = ""
  }
  for (i = 0; i < BW + 6; i++) rule = rule "─"
  tt = "<tt><span size=\047medium\047>" \
       " " span(c9, "CPU") "   " span(c8, sprintf("%d%% en uso", u["cpu"])) "\\n" \
       " " span(c8, rule) "\\n\\n" \
       section("", "P-cores", sprintf("%d × 2 hilos", pcores), psum / pn, p) "\\n\\n" \
       section("", "E-cores", sprintf("%d cores", en), esum / en, e) \
       "</span></tt>"
  printf "{\"text\":\"  %d%%\",\"tooltip\":\"%s\"}\n", u["cpu"], tt
}'
