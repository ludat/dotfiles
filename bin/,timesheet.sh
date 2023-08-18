#!/bin/bash

set -x

filename="$(date -d'1 month ago' +%Y-%m)_timesheet.csv"

xsv input --delimiter \; registro_de_horas.csv | xsv select '1,2,3,4' | \sd '^Fecha,Persona,Cantidad horas,Notas$' 'Date,Dev,Hours,Notes' | \sd '"(\d+),(\d+)"' '$1.$2' > $filename

SUMATORIA=$(xsv select '3' $filename | awk '{s+=$1} END {printf "%.2f", s}')

echo ",,," >> $filename
echo ",Total Hours,$SUMATORIA," >> $filename
