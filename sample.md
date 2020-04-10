# reorganizebycolumn



## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:


```r
library(tidyverse)
```

```
## Loading tidyverse: ggplot2
## Loading tidyverse: tibble
## Loading tidyverse: tidyr
## Loading tidyverse: readr
## Loading tidyverse: purrr
## Loading tidyverse: dplyr
```

```
## Conflicts with tidy packages ----------------------------------------------
```

```
## filter(): dplyr, stats
## lag():    dplyr, stats
```

```r
library(stringr)


df <- tibble(Gene.ID = "Gene.A" , b = "3DSA:3.90.25.10 (GENE3D); G3DSA:3.40.50.720 (GENE3D); IPR008030 (PFAM); PTHR43349 (PANTHER); PTHR43349:SF52 (PANTHER); IPR036291 (SUPERFAMILY)")

df
```

```
## # A tibble: 1 x 2
##   Gene.ID
##     <chr>
## 1  Gene.A
## # ... with 1 more variables: b <chr>
```

```r
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


}

head(df2)
```

```
## # A tibble: 2 x 5
##   Gene.ID              GENE3D          PANTHER        PFAM SUPERFAMILY
##     <chr>               <chr>            <chr>       <chr>       <chr>
## 1  Gene.A    3DSA:3.90.25.10        PTHR43349   IPR008030   IPR036291 
## 2  Gene.A  G3DSA:3.40.50.720   PTHR43349:SF52         <NA>        <NA>
```

```r
head(df3)
```

```
## # A tibble: 1 x 1
##   SUPERFAMILY
##         <chr>
## 1  IPR036291
```

```r
head(final.table)
```

```
##   Gene.ID                                GENE3D
## 1  Gene.A 3DSA:3.90.25.10 ,  G3DSA:3.40.50.720 
##                         PANTHER        PFAM SUPERFAMILY
## 1  PTHR43349 ,  PTHR43349:SF52   IPR008030   IPR036291
```
