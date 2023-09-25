# Carica la libreria tidyr per la manipolazione dei dati
library(tidyr)

# Controlla se è stato fornito un argomento per la directory da linea di comando
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Devi specificare la directory come argomento da linea di comando.")
}

# Prendi la directory dall'argomento della linea di comando
directory <- args[1]

# Ottieni la lista dei file nella directory con estensione .txt
file_list <- list.files(path = directory, pattern = "\\.txt$", full.names = TRUE)

# Inizializza un elenco vuoto per memorizzare i dati da tutti i file
data_list <- list()

# Leggi e elabora i dati da ciascun file
for (file_path in file_list) {
  # Leggi il file come un dataframe
  data <- read.table(file_path, header = FALSE, col.names = c("Kmer", "Counts"))
  
  # Aggiungi il nome del file come colonna
  data$File <- basename(file_path)
  
  # Aggiungi il dataframe alla lista
  data_list[[length(data_list) + 1]] <- data
}

# Unisci tutti i dati in un unico dataframe
combined_data <- do.call(rbind, data_list)

# Riempire i valori mancanti con 0
combined_data_filled <- pivot_wider(combined_data, names_from = File, values_from = Counts, values_fill = 0)

# Ordina le righe in base al Kmer
combined_data_filled <- combined_data_filled[order(combined_data_filled$Kmer),]

# Filtra escludendo i kmers che non compaiono in tutti i campioni
kmers <- combined_data_filled[rowSums(combined_data_filled != 0) == ncol(combined_data_filled), ]

# Scrivi il dataframe 'kmers' in una tabella con separatore di tabulazione
write.table(kmers, file = "output.txt", sep = "\t", quote = FALSE, row.names = FALSE)
