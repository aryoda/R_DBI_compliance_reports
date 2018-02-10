key.value.string.as.list <- function(key.value.string, str.trim = TRUE, keys.to.lower = TRUE) {

  # create one row per key/value pair
  DT <- data.table(key.value = strsplit(key.value.string, ";")[[1]])

    # create one separate key and value column
  DT[, c("key", "value") := tstrsplit(key.value, "=", fixed=TRUE)][]

  # Remove white spaces
  if (str.trim) {
    DT[, key   := stri_trim_both(key)]
    DT[, value := stri_trim_both(value)]
  }

  if (keys.to.lower) {
    DT[, key := tolower(key)]
  }

  # Mark all rows as belonging to the same group
  DT[, group := 1]

    # create one row for the group with one column per key/value pair (with the key as column name)
  res = dcast(DT, group ~ key, value.var = "value")

  # remove artificial group column
  res[, group := NULL]

  return(as.list(res))

}
