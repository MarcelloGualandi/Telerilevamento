# 1 - band 2 (blue)
# 2 - band 3 (green)
# 3 - band 4 (red)
# 4 - band 8 (NIR)

# Natural colors
im.plotRGB(sentdol, r=3, g=2, b=1) 

# False colors         (infrarosso)
im.plotRGB(sentdol, r=4, g=3, b=2) 
im.plotRGB(sentdol, r=3, g=4, b=2) 
im.plotRGB(sentdol, r=2, g=4, b=3)  viene fuori praticamente la stessa cosa. 

im.multiframe(1,2)
im.plotRGB(sentdol, r=2, g=4, b=3)
im.plotRGB(sentdol, r=3, g=4, b=2)

dev.off()
im.plotRGB(sentdol, r=3, g=2, b=4)
