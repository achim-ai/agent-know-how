// Usage: swift thumbnail.swift <input> <output.jpg> <scale>
// Lanczos downscale, then light luminance sharpening, saved as a high-quality JPEG.
import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation
import ImageIO
import UniformTypeIdentifiers

let args = CommandLine.arguments
let input = URL(fileURLWithPath: args[1]), output = URL(fileURLWithPath: args[2])
let scale = Double(args[3])!
guard let image = CIImage(contentsOf: input) else { fatalError("unreadable") }
let lanczos = CIFilter.lanczosScaleTransform()
lanczos.inputImage = image
lanczos.scale = Float(scale)
lanczos.aspectRatio = 1
let sharpen = CIFilter.sharpenLuminance()
sharpen.inputImage = lanczos.outputImage
sharpen.sharpness = 0.6
sharpen.radius = 1.2
let context = CIContext()
let result = sharpen.outputImage!.cropped(to: lanczos.outputImage!.extent)
guard let cg = context.createCGImage(result, from: result.extent),
    let dest = CGImageDestinationCreateWithURL(output as CFURL, UTType.jpeg.identifier as CFString, 1, nil)
else { fatalError("write") }
CGImageDestinationAddImage(dest, cg, [kCGImageDestinationLossyCompressionQuality: 0.95] as CFDictionary)
CGImageDestinationFinalize(dest)
print(cg.width, cg.height)
