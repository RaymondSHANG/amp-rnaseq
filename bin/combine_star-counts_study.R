#! /usr/bin/env Rscript
# JAE for Sage Bionetworks
# Combine individual sample count files into a sample x gene matrix file.
# April 12, 2017

library(argparse)
library(readr)
library(stringr)
library(tidyr)
library(purrr)
library(dplyr)

parser = ArgumentParser(description = "Combine sample STAR count files into a matrix file.")
parser$add_argument('file_list', type = "character", required = TRUE,
                    help = "List of STAR read count files to combine.")
parser$add_argument('--out_prefix', type = "character", required = TRUE,
                    help = "Prefix for output files.")
parser$add_argument('--sample_suffix', type = "character",
                    default = "ReadsPerGene.out.tab",
                    help = "Suffix to strip from sample filename [default %(default)s].")
parser$add_argument('--out_dir', default = getwd(), type = "character",
                    help = "Directory in which to save output [default %(default)s].")
args = parser$parse_args()

names(file_list) <- map_chr(file_list, function(file_path) {
    basename(file_path) %>%
        str_replace(sample_suffix, "")
    })
feature_order <- read_tsv(file_list[1], col_names = FALSE)[["X1"]]

combined_counts <- map_df(file_list, function(file_path) {
    sample_name <- str_replace(file_path, sample_suffix, "")
    read_tsv(file_path, col_names = FALSE) %>%
        select(X1, X2) %>%
        set_names(c("feature", "count")) %>%
        mutate(feature = factor(feature, levels = feature_order))
    },
    .id = "sample") %>%
    spread(sample, count)
