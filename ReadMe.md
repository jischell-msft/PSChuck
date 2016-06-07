# PSChuck
---
*Digging the pit of success for PowerShell module and function creation*

## Synopsis
Remembering to build correctly formatted comment based help, adding notes, using tests, adding a license - all good things to do, but why spend time thinking about them? 

PSChuck is a personal project to reduce the psychic load of function and module creation, in addition to encouraging best (better) practices for function and module development. Spend time thinking about the next great module to write, not how to update the manifest.

### Guiding Principles
- **The Pit of Success:** *In stark contrast to a summit, a peak, or a journey across a desert to find victory through many trials and surprises, we want our customers to simply fall into winning practices by using our platform and frameworks. To the extent that we make it easy to get into trouble we fail.* -Rico Mariani

- **Hanselman's First Law of Attention:** *It's not what you (do), it's what you ignore.* -Scott Hansleman

- **Hanselman's Second Law of Attention:** *The less you do, the more of it you can do.* -Scott Hanselman 

- **Hanselman's Third Law of Attention:** *Ignore as much as you can, stay focused on thing that captures your attention. You want to create that thing, and then when you've created that thing, exploit it in as many ways as possible* -Scott Hanselman 

### Functionality 
**New-ModuleOutline**

Creates the following directory and files:

	.\ModuleName
	    ModuleName.psm1
	    ModuleName.psd1
	    Readme.md
	    License.txt
	    Changes.txt
		.\build
		.\docs
	        functionToExport.md
	        functionNotToExport.md
		.\en-us
	    	about_ModuleName.help.txt
	    .\private
	        functionNotToExport.ps1
		.\public
	        functionToExport.ps1
	    .\tests
	        functionToExport.tests.ps1
			help.functionToExport.tests.ps1
			functionNotToExport.tests.ps1
			help.functionNotToExport.tests.ps1
	        
 **New-Function**

Content here

**Update-ModuleManifest**

Content here