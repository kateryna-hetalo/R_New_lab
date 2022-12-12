## Лабораторна робота № 2. Формат HDF5. 
В цій лабораторній роботі побудуємо за даними детектора гравітаційних волн 
LIGO графік злиття двох нейтронних зір. Подія GW170817 
https://uk.wikipedia.org/wiki/GW170817. Лабораторну роботу створено на основі 
https://losc.ligo.org/tutorial00/

1. Завантажте файл з даними за посиланням 
https://dcc.ligo.org/public/0146/P1700337/001/H-H1_LOSC_C00_4_V1-
1187006834-4096.hdf5
```
file<-tempfile(fileext=".hdf5")
options(timeout=600)
download.file(url="https://dcc.ligo.org/public/0146/P1700337/001/H-H1_LOSC_C00_4_V1-1187006834-4096.hdf5",destfile=file,mode="wb")
```

2. Встановить в R пакет для роботи з HDF5 файлами.
```
install.packages("BiocManager")
BiocManager::install("rhdf5")
library(rhdf5)
```
3. Виведіть зміст файлу командою h5ls().
```
h5ls(file)
```
Result:
``` 
                 group            name       otype  dclass      dim
0                    /            meta   H5I_GROUP                 
1                /meta     Description H5I_DATASET  STRING    ( 0 )
2                /meta  DescriptionURL H5I_DATASET  STRING    ( 0 )
3                /meta        Detector H5I_DATASET  STRING    ( 0 )
4                /meta        Duration H5I_DATASET INTEGER    ( 0 )
5                /meta        GPSstart H5I_DATASET INTEGER    ( 0 )
6                /meta     Observatory H5I_DATASET  STRING    ( 0 )
7                /meta            Type H5I_DATASET  STRING    ( 0 )
8                /meta        UTCstart H5I_DATASET  STRING    ( 0 )
9                    /         quality   H5I_GROUP                 
10            /quality          detail   H5I_GROUP                 
11            /quality      injections   H5I_GROUP                 
12 /quality/injections InjDescriptions H5I_DATASET  STRING        5
13 /quality/injections   InjShortnames H5I_DATASET  STRING        5
14 /quality/injections         Injmask H5I_DATASET INTEGER     4096
15            /quality          simple   H5I_GROUP                 
16     /quality/simple  DQDescriptions H5I_DATASET  STRING        7
17     /quality/simple    DQShortnames H5I_DATASET  STRING        7
18     /quality/simple          DQmask H5I_DATASET INTEGER     4096
19                   /          strain   H5I_GROUP                 
20             /strain          Strain H5I_DATASET   FLOAT 16777216
```
4. Зчитайте результати вимірів. Для цього зчитайте name Strain з групи strain
в змінну strain.
```
strain <- h5read(file, 'strain/Strain')
head(strain)
```
Result:
``` 
> head(strain)
[1] -2.391646e-18 -2.411660e-18 -2.427382e-18 -2.426351e-18 -2.427996e-18 -2.446291e-18
```
5. Також з «strain/Strain» зчитайте атрибут (функція h5readAttributes) 
Xspacing в змінну st та виведіть її. Це інтервал часу між вимірами.
```
st <- h5readAttributes(file, "strain/Strain")$Xspacing
```
Result:
``` 
$Xspacing
[1] 0.0002441406
```
6. Знайдіть час початку події та її тривалість. Для цього з групи meta зчитайте 
в змінну gpsStart name GPSstart та в змінну duration name Duration.
```
gpsStart <- h5read(file, 'meta/GPSstart')
duration <- h5read(file, 'meta/Duration')
```
Result:
``` 
> gpsStart
[1] 1187006834
> duration
[1] 4096
```
7. Знайдіть час закінчення події та збережіть його в змінну gpsEnd.
```
gpsEnd <- gpsStart + duration
```
Result:
``` 
> gpsEnd
[1] 1187010930
```
8. Створіть вектор з часу вимірів і збережіть у змінну myTime. Початок 
послідовності – gpsStart, кінець – gpsEnd, крок – st.
```
myTime <- seq(gpsStart, gpsEnd, by = st)
```
Result:
``` 
> myTime
   [1] 1187006834 1187006834 1187006834 1187006834 1187006834 1187006834 1187006834 1187006834
   [9] 1187006834 1187006834 1187006834 1187006834 1187006834 1187006834 1187006834 1187006834
  [17] 1187006834 1187006834 1187006834 1187006834 1187006834 1187006834 1187006834 1187006834
```
9. Побудуємо графік тільки для першого мільйону вимірів. Для цього створіть 
змінну numSamples, яка дорівнює 1000000.
10.Побудуйте графік за допомогою функції plot(myTime[0:numSamples], 
strain[0:numSamples], type = "l", xlab = "GPS Time (s)", ylab = "H1 Strain")
```
numSamples <- 1000000
plot(myTime[0:numSamples], strain[0:numSamples], type = "l", xlab = "GPS Time (s)", ylab = "H1 Strain")
```
Result:
![1000000 points LIGO dataset](lab_2_graph.jpg "LIGO data")
 
