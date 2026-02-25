library(ggplot2)
library(dplyr)
library(readr)
library(ggpubr)
library(scales)
library(cowplot)

##change to yours*
setwd("/Users/dairabel/manuscript_spruce/")

#data
# Expected columns: population, angsd_pi, spruce_pi, skmer_pi
data_stack <- read_csv("stats_corr_stack_750_new.csv", show_col_types = FALSE)
data_concat <- read_csv("stats_corr_concat_750_new.csv", show_col_types = FALSE)
colnames(data_stack) <- c("population", "angsd_pi", "spruce_pi", "skmer_pi")
colnames(data_concat) <- c("population", "angsd_pi", "spruce_pi", "skmer_pi")

# color map
color_map <- c(
  "Sillago sinica-Qingdao"   = "#6a51a3",
  "Sillago sinica-Dongying"  = "#807dba",
  "Sillago sinica-Wenzhou"   = "#9e9ac8",
  "Herring-Atlantic"         = "#1f77b4",
  "Herring-Atlantic-Ideo"    = "#2c83c0",
  "Herring-Atlantic-Karm"    = "#519dc7",
  "Herring-Atlantic-Mase"    = "#74add1",
  "Herring-Atlantic-Riso"    = "#a6cee3",
  "Finch-CF-Cristobal"       = "#1b9e77",
  "Finch-CF-Espanola"        = "#33b69d",
  "Finch-GC-Espanola"        = "#66c2a5",
  "Finch-GC-Genovesa"        = "#99d8c9",
  "Finch-Pina-Cocos"         = "#ccece6",
  "Sheep-Oula"               = "#fdae6b",
  "Sheep-Panou"              = "#fd8d3c",
  "Honeybee-Niupeng"         = "#ffcc00",
  "Honeybee-Zhongshui"       = "#e4b400"
)

# function for plots
make_corr_plot <- function(df, y_label, title_text, show_legend = FALSE) {
  ggplot(df, aes(x = angsd_pi, y = spruce_pi, color = population)) +
    geom_abline(intercept = 0, slope = 1, linetype = "dashed",
                color = "red", linewidth = 0.8) +
    geom_smooth(method = "lm", se = FALSE, color = "black", linewidth = 1) +
    geom_point(size = 3, alpha = 0.9) +
    scale_color_manual(values = color_map) +
    labs(
      x = expression("ANGSD"~pi~"Estimate"),
      y = y_label,
      color = "Population",
      title = title_text
    ) +
    stat_cor(
      method = "pearson",
      aes(label = paste(..r.label.., ..p.label.., sep = "~`,`~")),
      label.x.npc = "left",
      label.y.npc = "top",
      size = 5
    ) +
    stat_regline_equation(
      aes(label = paste("R² =", signif(..rr.., digits = 3))),
      label.x.npc = "left",
      label.y.npc = 0.9,
      size = 5
    ) +
    theme_minimal(base_size = 12) +
    theme(
      legend.position = ifelse(show_legend, "right", "none"),
      panel.border = element_rect(color = "black", fill = NA, linewidth = 1),
      plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
      plot.margin = margin(10, 10, 10, 10)
    )
}

#plotting
p_stack <- make_corr_plot(
  data_stack,
  y_label = expression("SPrUCE"~pi~"Estimate"),
  title_text = "Stacked",
  show_legend = FALSE
)

p_concat <- make_corr_plot(
  data_concat,
  y_label = expression("SPrUCE"~pi~"Estimate"),
  title_text = "Concatenated",
  show_legend = TRUE
)

#cowplot
title_box <- ggdraw() +
  draw_label("Flank 750", x = 0.5, hjust = 0.5, fontface = "bold", size = 14) +
  theme(
    plot.background = element_rect(fill = "grey90", color = NA),
    plot.margin = margin(5, 5, 5, 5)
  )

combined_row <- plot_grid(p_stack, p_concat, nrow = 1, rel_widths = c(1, 1.5))

final_plot <- plot_grid(
  title_box,
  combined_row,
  ncol = 1,
  rel_heights = c(0.1, 1)
)

final_plot

#save
ggsave("combined_correlation_750.png", final_plot, width = 7, height = 4, dpi = 500)
ggsave("combined_correlation_750.pdf", final_plot, width = 7, height = 4)

