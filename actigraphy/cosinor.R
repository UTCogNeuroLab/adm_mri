library(ggplot)

x <- seq.default(-1, 24, 0.001)
y <- 2*cos(-(1/3)*x + 5) -2
df <- data.frame(x, y)

x <- c(15, 15)
y <- c(-2, 0)
df2 <- data.frame(x, y)

ggplot(df, aes(x, y)) + 
  theme_classic() + 
  geom_line(size = 2) + 
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank(), axis.title=element_text(size=16,face="bold")) + 
  ylab("Activity") + xlab("Time\n 00:00 - 24:00") + 
  scale_x_continuous(limits = c(0, 24), expand = c(0, 0)) +
  #annotate("text", x = 5.8, y = -4.3, label = "Minimum", fontface = 2, color = 'darkblue', size = 8) + 
  geom_line(aes(x, y), data = df2, colour = "darkblue", size = 1.2) + 
  annotate("text", x = 20.5, y = -1, label = "Amplitude", fontface = 2, color = 'darkblue', size = 8) + 
  ggsave('~/Box/PsychFest/cosinor_amp.png', dpi = 300, height = 5, width = 12)
