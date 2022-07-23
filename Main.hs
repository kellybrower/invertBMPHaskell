--blockappsKB/Main.hs

import System.IO
import qualified Data.ByteString as B
import System.FilePath.Posix (takeExtension)
import System.Exit (exitSuccess)
import Data.Text (toLower, pack)


type ImgPath = String
type BMPBytes = B.ByteString

-- Helper Functions --
imgIsBMP :: ImgPath -> Bool
imgIsBMP s = takeExtension s == ".bmp"

bbpIs24 :: BMPBytes -> Bool
bbpIs24 b = B.index b 28 == 24 

pixeloffset :: BMPBytes -> Int 
pixeloffset b = fromIntegral $ B.index b 10 


--Assumes that the image provided is BMP and 24 bits per pixel
invert :: ImgPath -> IO ()
invert imgPath = do
       imgBytes <- B.readFile imgPath
       if (imgIsBMP imgPath) && (bbpIs24 imgBytes)
       then do
            let po             = pixeloffset imgBytes
            let bmpHeaders     = B.take po imgBytes  
            let pixels         = B.drop po imgBytes 
            let invertedPixels = B.map (255-) pixels
            let invertedBMP    = bmpHeaders <> invertedPixels
            --Recombine the BMP headers with inverted pixel data
            --to create a new BMP file identical to the original
            --but with the pixel colors inverted.
            B.writeFile ("Inverted" ++ imgPath) invertedBMP
       else error "This is not a 24 bbp BMP file."

main :: IO ()
main = do 
       putStrLn "Please provide the filename of a 24 bbp BMP image."
       putStrLn "\n\tExample files:\n\tblackbuck.bmp\n\tsample.bmp\n\t32bppsample.bmp\n\tsunflower.jpg\n\t"
       putStrLn "Please type the filename now (type 'exit' to exit the program): "
       img <- getLine
       if (toLower $ pack img) == pack "exit" --So, for instance eXiT works 
       then do putStr "Thanks. Exiting now.\n" 
               exitSuccess 
       else invert img
       putStrLn $ "Thanks. Check the current directory for the inverted image with the name: \nInverted" ++ img ++ "." 
