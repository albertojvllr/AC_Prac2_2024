#!/bin/bash

# Directorios de entrada y salida
results="results/"
resultats2="resultats2/"

# Crea la carpeta 'resultados2' si no existe
if [ ! -d ${resultats2} ]; then
    mkdir ${resultats2}
fi

# Recorre todos los archivos de la carpeta 'results' que sigan la nomenclatura establecida
for file in ${results}*; do
    # Extrae el nombre del archivo actual sin la ruta
    filename=$(basename "$file")
    
    # Obtiene los valores sim_IPC y bpred_dir_rate con grep
    sim_IPC=$(grep -E "^sim_IPC" "$file" | awk '{print $2}')
    bpred_dir_rate=$(grep -E "^bpred_.*\.bpred_dir_rate" "$file" | awk '{print $2}')

    # Guarda los resultados en un nuevo archivo en 'resultados2' con el mismo nombre
    output_file="${resultats2}${filename}.txt"
    echo "sim_IPC: $sim_IPC" > "$output_file"
    echo "bpred_dir_rate: $bpred_dir_rate" >> "$output_file"
done

echo "Extracción completada. Archivos guardados en ${resultats2}."

