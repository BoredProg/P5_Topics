class GradientImage extends PImage
{
    PApplet parent;
    int color1, color2;
    
    public GradientImage (PApplet parent, int theWidth, int theHeight )
    {
        super(theWidth, theHeight);
        this.parent = parent;
        
        color1 = 0xFF000000;
        color2 = 0xFFFFFFFF;
    }
    
    public GradientImage (PApplet parent, int theWidth, int theHeight, int _c1, int _c2 )
    {
        super(theWidth, theHeight);
        this.parent = parent;
        color1 = _c1;
        color2 = _c2;
    }
    
    void vertical ()
    {
        float as = (((color2 >> 24) & 0xFF) - ((color1 >> 24) & 0xFF)) / this.height;
        float rs = (((color2 >> 16) & 0xFF) - ((color1 >> 16) & 0xFF)) / this.height;
        float gs = (((color2 >>  8) & 0xFF) - ((color1 >>  8) & 0xFF)) / this.height;
        float bs = (((color2 >>  0) & 0xFF) - ((color1 >>  0) & 0xFF)) / this.height;
        
        for ( int ih=0; ih < this.height; ih++ )
        {
            
            int c = color( ((color1 >> 16) & 0xFF) + parent.round(rs * ih),
                           ((color1 >>  8) & 0xFF) + parent.round(gs * ih),
                           ((color1 >>  0) & 0xFF) + parent.round(bs * ih),
                           ((color1 >> 24) & 0xFF) + parent.round(as * ih)
                          );
            for ( int iw=0; iw < this.width; iw++ )
            {
                this.pixels[iw+(ih*this.width)] = c;
            }
        }   
    }
    
    
    void horizontal ()
    {
        float as = (((color2 >> 24) & 0xFF) - ((color1 >> 24) & 0xFF)) / this.width;
        float rs = (((color2 >> 16) & 0xFF) - ((color1 >> 16) & 0xFF)) / this.width;
        float gs = (((color2 >>  8) & 0xFF) - ((color1 >>  8) & 0xFF)) / this.width;
        float bs = (((color2 >>  0) & 0xFF) - ((color1 >>  0) & 0xFF)) / this.width;
        
        for ( int iw=0; iw < this.width; iw++ )
        {
            int c = color( ((color1 >> 16) & 0xFF) + parent.round(rs * iw),
                           ((color1 >>  8) & 0xFF) + parent.round(gs * iw),
                           ((color1 >>  0) & 0xFF) + parent.round(bs * iw),
                           ((color1 >> 24) & 0xFF) + parent.round(as * iw)
                          );
            for ( int ih=0; ih < this.height; ih++ )
            {
                this.pixels[iw+(ih*this.width)] = c;
            }
        }   
    }
}
