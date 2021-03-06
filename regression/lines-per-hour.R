#
# lines-per-hour.R, 23 Sep 18
#
# Data from:
# On the effectiveness of early life cycle defect prediction with Bayesian Nets
# Norman Fenton and Martin Neil and William Marsh and Peter Hearty and {\L}ukasz Radli\'{n}ski and Paul Krause
#
# Example from:
# Evidence-based Software Engineering: based on the publicly available data
# Derek M. Jones
#
# TAG effort LOC


source("ESEUR_config.r")


pal_col=rainbow(3)

loc_hour=read.csv(paste0(ESEUR_dir, "regression/10.1.1.157.6206.csv.xz"), as.is=TRUE)
loc_hour=subset(loc_hour, !is.na(KLoC))
loc_hour=loc_hour[order(loc_hour$Hours), ]

x_bounds=range(loc_hour$Hours)
y_bounds=range(loc_hour$KLoC)
        
Hours_KLoC=function(df)
{
plot(df$Hours, df$KLoC, col=pal_col[2],
        xlim=x_bounds, ylim=y_bounds,
        xlab="Effort (hours)", ylab="Lines of code (Kloc)\n")
lines(loess.smooth(df$Hours, df$KLoC, span=0.4), col=loess_col)

plh_mod=glm(KLoC ~ I(Hours^0.5), data=df)
                
plh_pred=predict(plh_mod, type="response", se.fit=TRUE)

lines(df$Hours, plh_pred$fit, col=pal_col[1])
lines(df$Hours, plh_pred$fit+plh_pred$se.fit*1.96, col=pal_col[3])
lines(df$Hours, plh_pred$fit-plh_pred$se.fit*1.96, col=pal_col[3])

return(plh_mod)
}


all_mod=Hours_KLoC(loc_hour)

