library(dplyr)
library(lubridate)
library(ggplot2)
library(readxl)
library(gganimate)
library(gifski)

solicitudes <- read_excel('data/Solicitudes de seguro de desempleo.xlsx',
                          col_names=c('Fecha', 'Montevideo', 'Interior', 'Web', 'Total'),
                          skip=1) %>%
  mutate(Fecha = as.Date(Fecha))

plot <- solicitudes %>%
  ggplot(aes(x=Fecha, y=Total)) +
  geom_line() +
  geom_point() +
  geom_text(aes(label = paste(month(Fecha, label = TRUE, abbr = TRUE), year(Fecha), sep = '-'))) +
  ggtitle('Solicitudes de seguro de desempleo en Uruguay') +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(breaks = seq(0, 90000, by = 10000)) +
  theme_minimal()

anim_plot <- plot +
  transition_reveal(Fecha) + 
  view_follow(fixed_y = TRUE, fixed_x = TRUE) +
  coord_cartesian(clip = 'off') + 
  ease_aes('cubic-in-out') +
  view_follow(fixed_y = TRUE, fixed_x = TRUE) 

animate(plot = anim_plot, 
        renderer = gifski_renderer("plot2.gif"),
        fps = 20, duration = 12, end_pause = 80)

anim_save("plot2.gif")

# animate(plot)
# options(gganimate.dev_args = list(height = 4, width = 4*1.777778, units = 'in', type = "cairo", res = 144))
