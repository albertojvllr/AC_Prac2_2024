#!/bin/bash

date

path=$(pwd)

results="results3/"
outputs="outputs/"
errors="errors/"

if [ ! -d ${results} ]; then
    mkdir ${results}
fi

# Ruta al directorio de programas
programs_root="${path}/programs/"

# Configuración de Simplescalar
simplescalar=${programs_root}"simplesim-3.0_acx2/sim-outorder"
fastfwd="-fastfwd 100000000"
maxinst="-max:inst 100000000"
memwidth="-mem:width 32"
memlat="-mem:lat 300 2"
parameters="${fastfwd} ${maxinst} ${memwidth} ${memlat}"

# Predictores y configuraciones
nottaken="nottaken"
taken="taken"

set_program() {
    prog_exe=${programs_root}"${curr_prog}/exe/${curr_prog}.exe"
    prog_in="${1}"
}

exe_bechmark() {
    prog_result="-redir:sim ${path}/${results}${curr_prog}_${1}_${2}"
    prog_out="${path}/${outputs}${curr_prog}_${1}_${2}.out"
    prog_err="${path}/${errors}${curr_prog}_${1}_${2}.err"

    # Mostrar el comando que se va a ejecutar
    echo "-----------------------------------------------------"
    echo "Ejecutando: ${simplescalar} ${parameters} ${branch_pred} ${prog_result} ${prog_exe} < ${prog_in} > ${prog_out} 2> ${prog_err}"
    echo "-----------------------------------------------------"

    if [ "$special" == "y" ]; then
        ${simplescalar} ${parameters} ${branch_pred} ${prog_result} ${prog_exe} < ${prog_in} > ${prog_out} 2> ${prog_err}
    else
        ${simplescalar} ${parameters} ${branch_pred} ${prog_result} ${prog_exe} ${prog_in} > ${prog_out} 2> ${prog_err}
    fi
}

run_benchmarks() {
    # Configuración para 'nottaken'
    branch_pred="-bpred ${nottaken}"
    echo "${curr_prog} ${nottaken}"
    exe_bechmark ${nottaken} "0"
    
    # Configuración para 'taken'
    branch_pred="-bpred ${taken}"
    echo "${curr_prog} ${taken}"
    exe_bechmark ${taken} "0"
}

# Configuración y ejecución de benchmarks
curr_prog="eon"
special=n
pushd "${programs_root}/${curr_prog}/data/ref"
set_program "chair.control.cook chair.camera chair.surfaces chair.cook.ppm ppm pixels_out.cook"
run_benchmarks
popd

curr_prog="vpr"
special=n
pushd "${programs_root}/${curr_prog}/data/ref"
set_program "net.in arch.in place.out dum.out -nodisp -place_only -init_t 5 -exit_t 0.005 -alpha_t 0.9412 -inner_num 2"
run_benchmarks
popd

curr_prog="ammp"
special=y
pushd "${programs_root}/${curr_prog}/data/ref"
set_program "${curr_prog}.in"
run_benchmarks
popd

curr_prog="applu"
special=y
pushd "${programs_root}/${curr_prog}/data/ref"
set_program "${curr_prog}.in"
run_benchmarks
popd

curr_prog="equake"
special=y
pushd "${programs_root}/${curr_prog}/data/ref"
set_program "inp.in"
run_benchmarks
popd

date

