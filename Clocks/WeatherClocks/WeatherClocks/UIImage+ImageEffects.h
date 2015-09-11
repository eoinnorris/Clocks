

@import Cocoa;

@interface NSImage (ImageEffects)

- (NSImage *)applyLightEffect;
- (NSImage *)applyExtraLightEffect;
- (NSImage *)applyDarkEffect;

- (NSImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(NSColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(NSImage *)maskImage;

@end
