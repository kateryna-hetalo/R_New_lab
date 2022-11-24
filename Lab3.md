Лабораторна робота № 3. Зчитування даних з WEB.    
В цій лабораторній роботі необхідно зчитати WEB сторінку з сайту IMDB.com зі
100 фільмами 2017 року виходу за посиланням    
«http://www.imdb.com/search/title?count=100&release_date=2017,2017&title_ty
pe=feature».

```
install.packages('rvest')
library('rvest')

webdata<-read_html("http://www.imdb.com/search/title?count=100&release_date=2017,2017&title_type=feature")


rank_data <- as.numeric(html_text(html_nodes(webdata,'.text-primary')))

title_data <- html_text(html_nodes(webdata,'.lister-item-header a'))

runtime_data <- html_text(html_nodes(webdata,'.text-muted .runtime'))
runtime_data <- as.numeric(gsub("min", "", runtime_data))

movies <- data.frame(Rank = rank_data, Title = title_data, Runtime = runtime_data, stringsAsFactors = FALSE)
```
1. Виведіть перші 6 назв фільмів дата фрейму
```
> head(movies)
  Rank                        Title Runtime
1    1 Той, хто біжить по лезу 2049     164
2    2                       Пастка     104
3    3                         Воно     135
4    4       Назви мене своїм ім'ям     132
5    5                   Джон Вік 2     122
6    6          Вартові Галактики 2     136
```
2. Виведіть всі назви фільмів с тривалістю більше 120 хв.
```
# display movies with runtime larger than 120
movies$Title[movies$Runtime>120]
```
```
> movies$Title[movies$Runtime>120]
 [1] "Той, хто біжить по лезу 2049"            
 [2] "Воно"                                    
 [3] "Назви мене своїм ім'ям"                  
 [4] "Джон Вік 2"                              
 [5] "Вартові Галактики 2"                     
 [6] "Форма води"                              
 [7] "Тор: Раґнарок"                           
 [8] "Логан: Росомаха"                         
 [9] "Диво-жінка"                              
[10] "Красуня і Чудовисько"                    
[11] "Людина-павук: Повернення додому"         
[12] "Roman J. Israel, Esq."                   
[13] "Квадрат"                                 
[14] "Вбивство священного оленя"               
[15] "Гра Моллі"                               
[16] "Мати!"                                   
[17] "Пірати Карибського моря: Помста Салазара"
[18] "Зоряні війни: Епізод 8 - Останні Джедаї" 
[19] "Kingsman: Золоте кільце"                 
[20] "Трансформери: Останній лицар"            
[21] "Вороги"                                  
[22] "Чужий: Заповіт"                          
[23] "Примарна нитка"                          
[24] "Валеріан і місто тисячі планет"          
[25] "Темні часи"                              
[26] "Сім сестер"                              
[27] "Король Артур: Легенда меча"              
[28] "Метелик"                                 
[29] "Saban's Могутні рейнджери"               
[30] "Форсаж 8"                                
[31] "Хатина"                                  
[32] "Постріл в безодню"                       
[33] "Усі гроші світу"                         
[34] "Вогнеборці"                              
[35] "Війна за планету мавп"   
```
3. Скільки фільмів мають тривалість менше 100 хв
```
# count movies with runtime less than 100
sum(movies$Runtime<100)
> sum(movies$Runtime<100)
[1] 13
```
