#WORLD BANK WORLD DEVELOPMENT INDICATORS (WDI) API

install.packages('WDI')
library('WDI')
install.packages('ggplot2')
library('ggplot2')
#search for data codes first (data names)

WDIsearch('gdp')
WDIsearch('gdp per capita')
WDIsearch('total population')


#A better way 
gdpvariables<-WDIsearch('gdp')
stockmarketvariables<-WDIsearch('stock market')
currentaccountvariables<-WDIsearch('curent account balance')

# if the above is empty alternatively you can enter search term by going here   

# https://data.worldbank.org.  then click details at the upper left corner to see the code

#once you open a graph see the details tab in the upper left corner for code details.

# 
# 
# or ypu can check out and download a large file with all the names here: 

# https://datacatalog.worldbank.org/search/dataset/0037712/World-Development-Indicators
# click the down  arrow next to Excel File or CSV


# Example Data Code:
#  "NY.GDP.PCAP.KD" id the code for    "GDP per capita (constant 2000 US$)"        
# Yu also need  country codes
# See country codes here 
# https://wits.worldbank.org/WITS/wits/WITSHELP/Content/Codes/Country_Codes.htm

dat = WDI(indicator='NY.GDP.PCAP.KD', country=c('TR','MYS','THA', 'BR', 'CHL', 'ARG', 'ZAF', 'COL','VEN'), start=1990, end=2023)


ggplot(dat, aes(year, NY.GDP.PCAP.KD, color=country)) + geom_line() + geom_point()+ggtitle( 'Kişi Başı Gelir (Sabit Dolar) Türkiye ve Benzer Ülkeler) (GSYH)')
  xlab('Sene') + ylab('Kişi Başı Milli Gelir (Dolar)')

# "NY.GDP.PCAP.PP.KD" "GDP per capita, PPP (constant 2005 international $)"


dat2 = WDI(indicator='NY.GDP.PCAP.PP.KD', country=c('TR','MYS','THA', 'BR', 'CHL', 'ARG', 'ZAF', 'COL','VEN', 'KOR', 'MX', 'MYS'), start=1990, end=2023)


ggplot(dat2, aes(year, NY.GDP.PCAP.PP.KD, color=country)) + geom_line() + geom_point() + ggtitle("Alım Gücü Paritesi- Kişi Başı GSYH(2005 Sabit $)   " ) +
  xlab('Sene') + ylab('Alım Gücü Paritesi- Kişi Başı GSYH(2005 Sabit $)' )



# "NY.GDP.MKTP.CD". # GDP (current US$)

dat3 = WDI(indicator='NY.GDP.MKTP.CD', country=c('TUR','KR','MX', 'BR'), start=1960, end=2023) 


ggplot(dat3, aes(year, NY.GDP.MKTP.CD, color=country)) + geom_line() + geom_point() +ggtitle('Gayri Safi Yurt İçi Hasıla (GSYH) $  Türkiye ve Benzeri ülkeler ')+
  xlab('Year') + ylab('GDP')


# "NY.GDP.PCAP.CD"  GDP per capita current USD


dat4 = WDI(indicator='NY.GDP.PCAP.CD', country=c('TUR', 'COL','MX', 'BR', 'CHL', 'ARG', 'ZAF','MYS'), start=2000, end=2024)


ggplot(dat4, aes(year, NY.GDP.PCAP.CD, color=country)) + geom_line() + geom_point() + ggtitle("Kişi Başı GSYH Türkiye ve Benzerleri (Cari $)  " ) +
  xlab('Sene') + ylab('Kişi Başı GSYH Türkiye ve Benzerleri (Cari $)')




# [6,] "BN.KLT.DINV.CD.ZS"    "Foreign direct investment (% of GDP)"                                    
# [6,] "BX.KLT.DINV.WD.GD.ZS"    "Foreign direct investment (% of GDP)"                                    


dat5 = WDI(indicator='BX.KLT.DINV.WD.GD.ZS', country=c('MX', 'BR', 'CHL', 'ARG', 'TUR', 'ZAF'), start=1990, end=2023)


ggplot(dat5, aes(year, BX.KLT.DINV.WD.GD.ZS, color=country)) + geom_line() +  geom_point() + ggtitle('GSYH yüzdesi Olarak Doğrudan Dış Yatırım  ') +
  xlab('Year') + ylab('GSYH yüzdesi Olarak Doğrudan Dış Yatırım ')



# NY.GDP.PCAP.KD.ZG" GDP per capita growth 

dat6 = WDI(indicator='NY.GDP.PCAP.KD.ZG', country=c('CHL', 'TUR', 'ZAF', 'ARG' , 'BR', 'MX'), start=1990, end=2023)

ggplot(dat6, aes(year, NY.GDP.PCAP.KD.ZG, color=country)) + geom_line() +  geom_point() + ggtitle('Kişi Başı GSYH Büyüme Oranı: Türkiye ve Şili  ') +
  xlab('Sene') + ylab('Kişi Başı GSYH Büyüme Oranı')



# NY.GDP.PCAP.KD.ZG" GDP per capita growth 
dat7 = WDI(indicator='NY.GDP.PCAP.KD.ZG', country=c('TUR', 'KOR'), start=1960, end=2023)

ggplot(dat7, aes(year, NY.GDP.PCAP.KD.ZG, color=country)) + geom_line() +  geom_point() + ggtitle('Kişi Başı GSYH Büyüme Oranı: Türkiye ve Kore  ') +
  xlab('Sene') + ylab('Kişi Başı GSYH Büyüme Oranı: Türkiye ve Kore ')

# GFDD.DM.02
# Stock market total value traded to GDP (%)

dat8 = WDI(indicator='GFDD.DM.02', country=c('MX', 'BR', 'CHL', 'ARG', 'TUR', 'ZAF', 'KOR'), start=1990, end=2023)

ggplot(dat8, aes(year, GFDD.DM.02, color=country)) + geom_line() +  geom_point() + ggtitle('GSYH ya oranla Borsa Toplam İşlem Hacmi (%):  ') +
  xlab('Sene') + ylab('GSYH ye oranla Borsa Toplam İşlem Hacmi(%) ')

# 

# CM.MKT.LCAP.GD.ZS
# Stock market capitalization to GDP (%)
dat9 = WDI(indicator='CM.MKT.LCAP.GD.ZS', country=c('MX', 'CHL', 'ARG', 'TUR', 'ZAF', 'BR','KOR'), start=1990, end=2022)

ggplot(dat9, aes(year, CM.MKT.LCAP.GD.ZS, color=country)) + geom_line() +  geom_point() + ggtitle('GSYH ya oranla Yerli Şirketlerin Borsa Değeri (%):  ') +
  xlab('Sene') + ylab('GSYH ya oranla Yerli Şirketlerin Borsa Değeri (%) ')

# GFDD.OM.02      Stock market return (%, year-on-year)

dat10 = WDI(indicator='GFDD.OM.02', country=c('MX', 'CHL', 'ARG', 'TR', 'ZAF', 'BR','KOR'), start=2010, end=2023)

ggplot(dat10, aes(year, GFDD.OM.02, color=country)) + geom_line() +  geom_point() + ggtitle('Borsa Getirisi (%, yıllık) Türkiye ve Benzer Ülkeler Karşılaştırması  ') +
  xlab('Sene') + ylab('Borsa Getirisi (%, yıllık)')

# FP.CPI.TOTL.ZG             Inflation, consumer prices (annual %)

dat11 = WDI(indicator='FP.CPI.TOTL.ZG', country=c('MX', 'CHL', 'ARG', 'TR', 'ZAF', 'BR','KOR'), start=2009, end=2023)

ggplot(dat11, aes(year, FP.CPI.TOTL.ZG  , color=country)) + geom_line() +  geom_point() + ggtitle(' Inflation, consumer prices (annual %) Türkiye ve Benzer Ülkeler Karşılaştırması  ') +
  xlab('Sene') + ylab(' Inflation, consumer prices  (%, yıllık)')


dat11 %>% 
ggplot(aes(x = year, y = FP.CPI.TOTL.ZG , color = country)) +
  geom_line() +
  geom_point() +
  labs(
    subtitle = " Enflasyon, Tüketici Fiyatları  (%, yıllık) Türkiye ve Benzer Ülkeler  '",
    color = "Country",
    y = "Yıllık Enflasyon",
    x = "Sene"
  ) +
  scale_x_continuous(breaks = 2010:2022)
# 
# BN.CAB.XOKA.GD.ZS  
# "Current Account Balance, %GDP"  
dat12 =  WDI(indicator='BN.CAB.XOKA.GD.ZS', country=c('MX', 'CHL', 'ARG', 'TR', 'ZAF', 'BR','KOR'), start=2009, end=2023)


dat12 %>% 
  ggplot(aes(x = year, y = BN.CAB.XOKA.GD.ZS , color = country)) +
  geom_line() +
  geom_point() +
  labs(
    subtitle = " Cari Açığın GSYH ye oranı (%): Türkiye ve Benzer Ülkeler  '",
    color = "Country",
    y = "Cari Açığın GSYH ye oranı (%)",
    x = "Sene"
  ) +
  scale_x_continuous(breaks = 2010:2023)


# Exports of goods and services (% of GDP)
# NE.EXP.GNFS.ZS
dat15 = WDI(indicator='NE.EXP.GNFS.ZS', country=c('MX', 'CHL', 'ARG', 'TUR', 'ZAF', 'BR','KOR'), start=1990, end=2022)

dat15 %>% 
  ggplot(aes(x = year, y =NE.EXP.GNFS.ZS , color = country)) +
  geom_line() +
  geom_point() +
  labs(
    subtitle = " İhracatın GSYH ye oranı:Türkiye ve Benzer Ülkeler  '",
    color = "Country",
    y = "İhracatın GSYH ye oraanı",
    x = "Sene"
  ) 

# Exports of goods and services (current US$)
# NE.EXP.GNFS.CD
dat16 = WDI(indicator='NE.EXP.GNFS.CD', country=c('MX', 'CHL', 'ARG', 'TUR', 'ZAF', 'BR','KOR'), start=1990, end=2022)

dat16 %>% 
  ggplot(aes(x = year, y =NE.EXP.GNFS.CD , color = country)) +
  geom_line() +
  geom_point() +
  labs(
    subtitle = " İhracat (Cari $). Türkiye ve Benzer Ülkeler  '",
    color = "Country",
    y = "İhracat (Cari $)",
    x = "Sene"
  ) 

#does not look nice on y axis

dat17 <- dat16
dat17$ihracat = dat16$NE.EXP.GNFS.CD/1000000000

# now redo the graph

dat17 %>% 
  ggplot(aes(x = year, y =ihracat , color = country)) +
  geom_line() +
  geom_point() +
  labs(
    subtitle = " İhracat (Cari Milyar $). Türkiye ve Benzer Ülkeler  '",
    color = "Country",
    y = "İhracat (Cari Milyar $)",
    x = "Sene"
  ) 


# 
# BN.CAB.XOKA.CD
# Current Account Balance

dat13 =  WDI(indicator='BN.CAB.XOKA.CD', country=c('TR', 'ZAF', 'BR'), start=2009, end=2023)

#This is for preventing large numbers to show up as powers of e 

require(scales)
point <- format_format(big.mark = " ", decimal.mark = ",", scientific = FALSE)



dat13 %>% 
  ggplot(aes(x = year, y = BN.CAB.XOKA.CD , color = country)) +
  geom_line() +
  geom_point() +
  labs(
    subtitle = " Cari Açık (cari $ cinsinden): Türkiye ve Benzer Ülkeler  '",
    color = "Country",
    y = "Cari Açık ($)",
    x = "Sene") 


# To show values for each point use
# +
#   geom_text(aes(label = round(BN.CAB.XOKA.CD, 1)),
#             vjust = "inward", hjust = "inward",
#             show.legend = FALSE)

dat13 %>% 
  ggplot(aes(x = year, y = BN.CAB.XOKA.CD , color = country)) +
  geom_line() +
  geom_point() +
  labs(
    subtitle = " Cari Açık (cari $ cinsinden): Türkiye , Brezilya, ve Güney Afrika   '",
    color = "Country",
    y = "Cari Açık ($)",
    x = "Sene") +
     geom_text(aes(label = round(BN.CAB.XOKA.CD, 1)),
               vjust = "inward", hjust = "inward",
               show.legend = FALSE)
  


#but now we need to clear up 

short <- scales::unit_format(unit = 'M', scale = 1e-6)(dat13$BN.CAB.XOKA.CD)
# %>%  takes the left hand side and puts it in the first argument in the right hand side
dat13 %>% 
  ggplot(aes(x = year, y = BN.CAB.XOKA.CD , color = country)) +
  geom_line() +
  geom_point() +
  labs(
    subtitle = " Cari Açık (cari $ cinsinden): Türkiye ve Benzer Ülkeler  '",
    color = "Country",
    y = "Cari Açık ($)",
    x = "Sene") +
  geom_text(aes(label = short, 
            vjust = "inward", hjust = "inward",
  ))


dat13 %>% 
  ggplot(aes(x = year, y = BN.CAB.XOKA.CD , color = country)) +
  geom_line() +
  geom_point() +
  labs(
    subtitle = " Cari Açık (cari $ cinsinden): Türkiye ve Benzer Ülkeler  '",
    color = "Country",
    y = "Cari Açık ($)",
    x = "Sene") 


#We want calculate CA Deficit per capita

# #POPULATION
# SP.POP.TOTL

#We get current account first
dat13 <-  na.omit(WDI(indicator='BN.CAB.XOKA.CD', country=c('TR', 'BR', 'ARG', 'MX', 'ZAF'), start=2000, end=2023))

#than we get population
pop <- na.omit(WDI(indicator='SP.POP.TOTL', country=c('TR', 'BR', 'ARG', 'MX', 'ZAF'), start=2000, end=2023))

#now we join them using inner_join function from dplyr package
library(dplyr)

joined_data <- inner_join(dat13, pop, by="iso2c")

#the below works better (correct) check this later

joined_data <-merge(cbind(dat13, X=rownames(dat13)), cbind(pop, variable=rownames(pop)))

#now we calculate CA per head
joined_data$perhead = joined_data[,5]/joined_data[,9] 

#or we can calculate it like this using the mutate from dplyr package
joined_data <-mutate(joined_data, perhead = BN.CAB.XOKA.CD/SP.POP.TOTL)

joined_data %>% 
  ggplot(aes(x = year.x, y = perhead , color = country.y)) +
  geom_line() +
  geom_point() +
  labs(
    subtitle = " Kişi Başı Cari Açık ($) : Türkiye ve Benzer Ülkeler  '",
    color = "Country",
    y = "Cari Açık ($)",
    x = "Sene") 


ggplot(joined_data, aes(x = year.x, y = perhead  , color=country.x)) + geom_line()  + ggtitle('Kişi Başı Cari Açık($) Türkiye ve Brezilya  ') +
  xlab('Sene') + ylab(' Kişi Başı Cari Açık  ($)  ')

#these graphs look not right becaue there are 2 unmatched year columns so delete one of them 
joined_data %>% select(-(year.y))
#or better
joined_data <- select(joined_data,-(year.y))

#also remove variables staring with iso 
joined_data <- select(joined_data, -contains('iso')) 

#finally we also dpnt need country y
joined_data <- select(joined_data,-(country.y))
rects <- data.frame


ggplot(joined_data, aes(x = year, y = perhead  , color=country)) +    annotate('rect', xmin=2000, xmax=2022,ymin= min(joined_data$perhead), ymax = 0,fill='darkgoldenrod1') +    annotate('rect', xmin=2000, xmax=2022,ymin=0, ymax = max(joined_data$perhead),fill='lightblue')+ annotate("text", x= 2014 , y= 120 , label ="CARİ FAZLA" )  + annotate("text", x= 2014 , y= -800 , label ="CARİ AÇIK" )+ geom_hline(yintercept = c(-1000,0,max(joined_data$perhead)), linetype ='dashed')       + geom_line()  + geom_point()+ ggtitle('Kişi Başı Cari Açık($) Türkiye ve Benzer Ülkeler  ') +
  xlab('Sene') + ylab(' Kişi Başı Cari Açık  ($)  ')



#without th erectangles
ggplot(joined_data, aes(x = year, y = perhead  , color=country)) + annotate("text", x= 2014 , y= 120 , label ="CARİ FAZLA" )  + annotate("text", x= 2014 , y= -800 , label ="CARİ AÇIK" )+ geom_hline(yintercept = c(-1000,0,max(joined_data$perhead)), linetype ='dashed')       + geom_line()  + geom_point()+ ggtitle('Kişi Başı Cari Açık($) Türkiye ve Benzer Ülkeler  ') +
  xlab('Sene') + ylab(' Kişi Başı Cari Açık  ($)  ')





#lets change tedcolor more transparent (lets use Wes Anderson Colors)
# Install
install.packages("wesanderson")
# Load
library(wesanderson)


# 6
# GFDD.DM.01
# Stock market capitalization to GDP (%)
# 7807
# GFDD.DM.02
# Stock market total value traded to GDP (%)



# 
# > WDIsearch('gdp')[1:10,]
# indicator              name                                                                      
# [1,] "BG.GSR.NFSV.GD.ZS"    "Trade in services (% of GDP)"                                            
# [2,] "BM.KLT.DINV.GD.ZS"    "Foreign direct investment, net outflows (% of GDP)"                      
# [3,] "BN.CAB.XOKA.GD.ZS"    "Current account balance (% of GDP)"                                      
# [4,] "BN.CUR.GDPM.ZS"       "Current account balance excluding net official capital grants (% of GDP)"
# [5,] "BN.GSR.FCTY.CD.ZS"    "Net income (% of GDP)"                                                   
# [6,] "BX.KLT.DINV.WD.GD.ZS"    "Foreign direct investment (% of GDP)"                                    
# [7,] "BN.KLT.PRVT.GD.ZS"    "Private capital flows, total (% of GDP)"                                 
# [8,] "BN.TRF.CURR.CD.ZS"    "Net current transfers (% of GDP)"                                        
# [9,] "BNCABFUNDCD_"         "Current Account Balance, %GDP"                                           
# [10,] "BX.KLT.DINV.WD.GD.ZS" "Foreign direct investment, net inflows (% of GDP)" 
# WDIsearch uses grep and ignores cases, so you can also use regular expressions. For instance, if you are looking for GDP per capita in constant dollars:
#   
#   WDIsearch('gdp.*capita.*constant')
# indicator           name                                                 
# [1,] "GDPPCKD"           "GDP per Capita, constant US$, millions"             
# [2,] "NY.GDP.PCAP.KD"    "GDP per capita (constant 2000 US$)"                 
# [3,] "NY.GDP.PCAP.KN"    "GDP per capita (constant LCU)"                      
# [4,] "NY.GDP.PCAP.PP.KD" "GDP per capita, PPP (constant 2005 international $)"