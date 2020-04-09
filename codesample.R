library(tidyverse)
library(stringr)


df <- tibble(Gene.ID = "Gene.A" , b = "3DSA:3.90.25.10 (GENE3D); G3DSA:3.40.50.720 (GENE3D); IPR008030 (PFAM); PTHR43349 (PANTHER); PTHR43349:SF52 (PANTHER); IPR036291 (SUPERFAMILY)")

df


for (x in unique(df$Gene.ID)){
  
  final.table <- NULL
  final.table <- data.frame(Gene.ID = x)
  
  
  ##separating  
  df2 <- df %>% separate(b, c("c","d","e","f","g","h","i","j","k","l","m"),";",fill="right") %>%
    select_if(~ !any(is.na(.))) %>%
    group_by(Gene.ID) %>%
    gather(key="Variable",value="Value",-Gene.ID) %>%
    select(Gene.ID,Value) %>%
    separate(Value,c("value","title"),sep='\\(') %>%
    separate(title,c("title","extra"),sep="\\)") %>%
    select(Gene.ID,title,value) %>%
    group_by_at(vars(-value)) %>%
    mutate(row_id=1:n()) %>% ungroup() %>%
    spread(key=title,value=value) %>%
    select(-row_id)
  
  head(df2)
  
  for(i in names(df2)[-1]) {
    df3 <- df2 %>%
      select(i)
    names(df3) <- "foo"
    df3 <- df3 %>%
      na.omit() %>%
      summarize(foo = str_c(foo, collapse = ", "))
    names(df3) <- i
    head(df3)
    final.table <- cbind(final.table,df3)
    
  }
  
  head(final.table)
  
}





