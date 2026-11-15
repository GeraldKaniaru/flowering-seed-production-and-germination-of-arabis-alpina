# Render the supplementary analysis report from the analysis project root.
if (!file.exists("arabis analysis.Rproj")) {
  stop("Open 'arabis analysis.Rproj' and run source('scripts/rmarkdown.R').")
}
for (package in c("rmarkdown", "knitr", "magick", "gt")) {
  if (!requireNamespace(package, quietly = TRUE)) {
    stop("Install the required package: ", package)
  }
}

# Prefer Pandoc already configured in RStudio or on PATH.
if (!rmarkdown::pandoc_available()) {
  local_app <- Sys.getenv("LOCALAPPDATA")
  program_files <- Sys.getenv("ProgramFiles")
  roots <- c(file.path(local_app, "Programs", "RStudio"),
             file.path(program_files, "RStudio"))
  candidates <- c(file.path(roots, "resources/app/bin/quarto/bin/tools"),
                  file.path(roots, "resources/app/bin/pandoc"))
  found <- candidates[file.exists(file.path(candidates, "pandoc.exe"))]
  if (length(found)) Sys.setenv(RSTUDIO_PANDOC = found[[1L]])
}
if (!rmarkdown::pandoc_available()) {
  stop("Pandoc is required. Open the project in RStudio or add Pandoc to PATH.")
}

if (.Platform$OS.type == "windows") invisible(Sys.setlocale("LC_CTYPE", ".UTF-8"))

project_root <- normalizePath(".", winslash = "/")
output_folder <- file.path(project_root, "outputs", "rmarkdown")
dir.create(output_folder, recursive = TRUE, showWarnings = FALSE)
rmarkdown::render(
  input = file.path(project_root, "scripts", "rmarkdown.Rmd"),
  output_file = "Arabis_alpina_supplementary_methods.html",
  output_dir = output_folder,
  knit_root_dir = project_root,
  envir = new.env(parent = globalenv())
)
