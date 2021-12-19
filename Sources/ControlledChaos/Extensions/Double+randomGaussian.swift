//  Created by B.T. Franklin on 1/4/19

import Foundation

extension Double {
    
    private static var _queudGaussian: Double?
    
    /**
     Returns a random Gaussian double with the provided standard deviation and mean values, which default to a
     standard deviation of 1 and a mean of 0 if not provided.
     */
    public static func randomGaussian(withStandardDeviation standardDeviation: Double = 1.0,
                                      withMean mean: Double = 0.0,
                                      withMaximum maximum: Double = .infinity,
                                      withMinimum minimum: Double = -.infinity) -> Double {
        
        var result: Double?
        repeat {
            
            let baseGaussian: Double
            if let gaussian = Double._queudGaussian {
                Double._queudGaussian = nil
                baseGaussian = gaussian
                
            } else {
                var value1, value2, sumOfSquares: Double
                
                repeat {
                    value1 = 2 * Double.random(in: 0...1) - 1
                    value2 = 2 * Double.random(in: 0...1) - 1
                    sumOfSquares = value1 * value1 + value2 * value2
                } while sumOfSquares >= 1 || sumOfSquares == 0
                
                let multiplier = sqrt(-2 * log(sumOfSquares)/sumOfSquares)
                Double._queudGaussian = value2 * multiplier
                
                baseGaussian = value1 * multiplier
            }
            
            let parameterAdjustedGaussian = baseGaussian * standardDeviation + mean
            if (minimum...maximum).contains(parameterAdjustedGaussian) {
                result = parameterAdjustedGaussian
            }
        } while result == nil
        
        return result!
    }
    
}
