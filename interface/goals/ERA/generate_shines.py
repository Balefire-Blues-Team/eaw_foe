#%%
import re
import os
root = os.path.dirname(os.path.realpath(__file__))
class Focus:
    def __init__(self, name, filePath):
        self.name = name
        self.file = filePath

definedShineSprite = """
	spriteType = {
		name = "focusTypeName"
		texturefile = "focusTypeTextureFile"
		effectFile = "gfx/FX/buttonstate.lua"
		animation = {
			animationmaskfile = "focusTypeTextureFile"
			animationtexturefile = "gfx/interface/goals/shine_overlay.dds" 	# <- the animated file
			animationrotation = -90.0		# -90 clockwise 90 counterclockwise(by default)
			animationlooping = no			# yes or no ;)
			animationtime = 0.75				# in seconds
			animationdelay = 0			# in seconds
			animationblendmode = "add"       #add, multiply, overlay
			animationtype = "scrolling"      #scrolling, rotating, pulsing
			animationrotationoffset = { x = 0.0 y = 0.0 }
			animationtexturescale = { x = 1.0 y = 1.0 }
		}
		animation = {
			animationmaskfile = "focusTypeTextureFile"
			animationtexturefile = "gfx/interface/goals/shine_overlay.dds" 	# <- the animated file
			animationrotation = 90.0		# -90 clockwise 90 counterclockwise(by default)
			animationlooping = no			# yes or no ;)
			animationtime = 0.75				# in seconds
			animationdelay = 0			# in seconds
			animationblendmode = "add"       #add, multiply, overlay
			animationtype = "scrolling"      #scrolling, rotating, pulsing
			animationrotationoffset = { x = 0.0 y = 0.0 }
				animationtexturescale = { x = 1.0 y = 1.0 }
		}
		legacy_lazy_load = no
	}
"""
openingString = "spriteTypes = {"
closingString = "}"

for filename in os.listdir(root):
    if filename.endswith(".gfx") and "shine" not in filename and "national_focuses" in filename:
        focusesInFile = []
        print(os.path.join(filename))
        file = open(filename)
        text = file.read()
        ### Split file
        focusFileSplit = re.split("(spriteType = {[\w=\"/.\s]+})", text)
        for potentialFocusString in focusFileSplit:
            ### Find a sprite definition
            focusString = re.search("(spriteType = {[\w=\"/.\s]+})", potentialFocusString)
            ### Cut trash
            try:
                ## Create a focus object for each focus
                currenFocusName = re.search("(?<=name = \")([_\w]+)(?=\")", focusString.group())
                currentFocusPath = re.search("(?<=texturefile = \")[\w\/.]+(?=\")", focusString.group())
                currentFocus = Focus(currenFocusName.group(), currentFocusPath.group())
                focusesInFile.append(currentFocus)
            except:
                continue
        print( "Focuses Found: " + str(len(focusesInFile)) )
        file.close()
        ### Create new file name
        splitName = re.split("\.", filename)
        newName = splitName[0] + "_shine." + splitName[1]
        print ("New File Name: " + newName)
        shineFile = open( newName, "w", encoding="utf-8", newline="\r\n")
        shineFile.close()
        shineFile = open( newName, "a")
        shineFile.write(openingString)
        for focusType in focusesInFile:
            currentFocusSprite = definedShineSprite
            currentFocusName = str(focusType.name) + "_shine"
            currentFocusFile = str(focusType.file)
            currentFocusSprite = re.sub("focusTypeName", currentFocusName, currentFocusSprite)
            currentFocusSprite = re.sub("focusTypeTextureFile", currentFocusFile, currentFocusSprite)
            shineFile.write(currentFocusSprite)
        shineFile.write(closingString)
        shineFile.close()
        continue
    else:
        continue
# %%
