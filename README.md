Author: Kelly Brower
Email:  kbrower77@gmail.com

This is a ReadMe for understanding how to compile Main, which inverts 24 bpp 
BMP files. 
This was created to answer an interview question provided to me
by Blockapps (https://blockapps.net)
It asks to take a 24 bit per pixel (bbp) BitMap (BMP) image and invert its 
colors.  The code provided does so without destroying the original image 
(it creates a new one).

#Requisites:

You must have GHC installed.  
If you don't you can find a download and installation instructions
here: https://www.haskell.org/ghc/

As shipped, this ReadMe should be a part of a github repository called "invertBMPHaskell" along with the following files.

-32bppsample.bmp
-blackbuck.bmp
-Main.hs
-README.txt
-sample.bmp
-sunflower.jpg

32bppsample.bmp is to show that this program exits with error if a BMP file with
a bpp other than 24 is provided.

blackbuck.bmp and sample.bmp are provided to show that regardless of DIB header
size that a 24 bpp BMP image will successfully be created as an inverted copy 
of the original.

sunflower.jpg is provided to show that an image of the wrong format will exit 
with error.

#Instructions:

To run this program, open a terminal window and change 
directories to the folder containing invertedBMPHaskell

Then type this into your terminal: 

`$ ghc Main.hs && ./Main`

You will then be prompted to provide a filename.

To demonstrate the requested functionality, try typing the name of an image.

For blackbuck.bmp, you should see the program succeed by printing a
success message, exiting and leaving the "Invertedblackbuck.bmp" image in
the folder blockappsKB.

Since Main.hs is now compiled, simply call the Main program again
by typing the following into your terminal:

`$ ./Main`

Try this for the remaining images and any you might download to test.
(Just make sure they are placed in the folder blockappsKB)

Essentially, the file has two headers (BMP, DIB) which provide metadata.
Within this metadata, byte 14 (within the BMP Header) provides the index 
for which the pixel data begins.  This is integral in having this program work
with different 24 bpp BMP files, since any BMP, although having a standard BMP
header, often has varying amounts of filler data between the header and the 
pixel data.
Fortunately, once we know where the pixel data is, we know where it ends,
too, since the pixel data is the last chunk of bytes the BMP file.
 
For instance, sample.bmp has a different sized DIB header (108 bytes) than
blackbuck.bmp (40 bytes). This is handled easily since the BMP header defines 
where the pixel data starts.

A detailed explanation of BMP files can be found here: 
https://en.wikipedia.org/wiki/BMP_file_format

For both sunflower.jpg and 32bppsample.bmp you should get an error message since
for this interview question, the simplifying assumption was made that it is
only meant to handle 24 bpp BMP files.

Exit functionality is implemented as well if, for some reason, you would like to exit the program without scanning a file.

Try verifying that it worked by displaying an image and its
inverted version side by side...
then inverting the colors on your screen!

#Bonus

By adding `|| B.index b 28 == 32` to the end of line 18 of Main.hs,
this program can handle 32 bpp BMP
images such as the one provided.  However, the interview prompt explicitly
asked to stick with one bpp. Open up the file and edit it to see it works
by calling 32bppexample.bmp after editing line 18

#Limitations

Ostensibly, you could provide a file that has the .bmp extension, and has byte
value 24 at index 28 that wasn't an image.  
However, this file would also have to have enough bytes to mimic the structure
of a BMP image, without being a BMP.
This means that this file wouldn't open as an image anyway, even before running
Main on it.  
Main would simply edit the values of the bytes at the prescribed value starting at byte 10 until the end of the file and save this as new copy of the "image". 
Otherwise, if this ByteString somehow made it past the guards of checking the
extension and bpp value, but one of the Data.ByteString functions failed, (such as there being a call to an index out of range)
the program would exit with an error anyway, although not explicitly accounted
for by the author.

Also if you don't take the precaution to follow the instructions and 
run Main from the terminal within the folder to which you downloaded invertedBMPHaskell, you can get some funny behavior
such as the error message appending "Inverted" to the front of it. (At least I did)

Try double clicking the executable in your Finder and provide filepaths in lieu
of the filenames requested and see what happens!
