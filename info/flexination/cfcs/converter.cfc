<cfcomponent name="converter" displayname="converter CFC" hint="This component handles all the Uploaded Image conversion interactions">

	<cffunction name="getVisitorIP" displayname="Get IP Address" hint="Returns Visitor's' IP address" access="remote" output="false" returntype="string">
		<cfset sIP = "#CGI.Remote_Addr#">
		
		<cfreturn sIP />
	</cffunction>
	
	<cffunction name="doUpload" displayname="Save Uploaded Image to PNG" hint="Saves an Uploaded Image to PNG" access="remote" output="false" returntype="string">
		<cfargument name="pngbytes" type="binary" required="true" />
		<cfargument name="ip_suffix" type="string" required="true" />
		<cfscript>
			var myUUID = "";
			var PNGFileName = "";
			myUUID = CreateUUID();
			PNGFileName = arguments.ip_suffix & "_" & myUUID;
		</cfscript>
		<!--- save the PNG --->
		<cftry>
			<!--- create a FileOutputStream --->
			<cfobject type="java" action="CREATE" class="java.io.FileOutputStream" name="oStream">
			<cfscript>
				// call init method, passing in the full path to the desired jpg
				oStream.init(expandPath("../../../converted_pngs/converted_#arguments.ip_suffix#_#myUUID#.png"));
	        	oStream.write(arguments.pngbytes);
	        	oStream.close();
				// call the convertToVector
				convertToVector(PNGFileName);
			</cfscript>
					
		<cfcatch type="any">
			<cfthrow message="#cfcatch.message# #cfcatch.detail# #cfcatch.RootCause#">
		</cfcatch>	
		</cftry>		

		<cfreturn PNGFileName />
	</cffunction>

	<cffunction name="convertToVector" displayname="Convert To Vector" hint="Converts a PNG to a SVG" access="remote" output="false" returntype="any">
		<cfargument name="PNGName" type="string" required="true" />
			<cfscript>
				var KvecParams = "";
				var sIP = getVisitorIP();
				if (sIP neq "127.0.0.1") {
					KvecParams = "D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\converted_pngs\converted_#arguments.PNGName#.png" & " " & "D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\converted_svgs\converted_#arguments.PNGName#.svg";
				} else {
					KvecParams = "C:\inetpub\wwwroot\flextraining\ImageToPDF\converted_pngs\converted_#arguments.PNGName#.png" & " " & "C:\inetpub\wwwroot\flextraining\ImageToPDF\converted_svgs\converted_#arguments.PNGName#.svg";
				}
			</cfscript>
			
		<!--- Sleep 1 second --->
		<cfset thread = CreateObject("java", "java.lang.Thread")>
		<cfset thread.sleep(1000)>
			
		<cftry>
			<cfscript>
				myObject = createObject("java", "java.lang.Runtime").getRuntime();
				if (sIP neq "127.0.0.1") {
					myObject.exec("D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\kvec\KVEC " & KvecParams & " -format svg");
				} else {
					myObject.exec("C:\inetpub\wwwroot\flextraining\ImageToPDF\kvec\KVEC " & KvecParams & " -format svg");
				}
			</cfscript>
		<cfcatch type="any">
			<cfthrow message="#cfcatch.message# #cfcatch.detail# #KvecParams#">
		</cfcatch>	
		</cftry>		

		<cfreturn />
	</cffunction>
	
	<cffunction name="convertToPDF" displayname="Save to PDF" hint="Saves a PDF" access="remote" output="false" returntype="boolean">
		<cfargument name="SVGName" type="string" required="true" />
		<cfscript>
			var blnSuccess = false;
			var BatikParams = "";
			var PDFFile = "";
			var sIP = getVisitorIP();
			if (sIP neq "127.0.0.1") {
				BatikParams = "D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\converted_svgs\converted_#arguments.SVGName#.svg -d D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\converted_pdfs\converted_#arguments.SVGName#.pdf";
			} else {
				BatikParams = "C:\inetpub\wwwroot\flextraining\ImageToPDF\converted_svgs\converted_#arguments.SVGName#.svg -d C:\inetpub\wwwroot\flextraining\ImageToPDF\converted_pdfs\converted_#arguments.SVGName#.pdf";
			}			
		</cfscript>
		
		<!--- convert the SVG to a PDF --->
		<cftry>
			<cfscript>
				myObject = createObject("java", "java.lang.Runtime").getRuntime();
				if (sIP neq "127.0.0.1") {
					myObject.exec("D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\batik-1.7\jre\bin\java -jar D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\batik-1.7\batik-rasterizer.jar " & BatikParams & " -m application/pdf");
				} else {
					myObject.exec("C:\inetpub\wwwroot\flextraining\ImageToPDF\batik-1.7\jre\bin\java -jar C:\inetpub\wwwroot\flextraining\ImageToPDF\batik-1.7\batik-rasterizer.jar " & BatikParams & " -m application/pdf");
				}
				// sleep 4 seconds
				thread = CreateObject("java", "java.lang.Thread");
				thread.sleep(4000);
				if (sIP neq "127.0.0.1") {
					PDFFile = "D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\converted_pdfs\converted_#arguments.SVGName#.pdf";
				} else {
					PDFFile = "C:\inetpub\wwwroot\flextraining\ImageToPDF\converted_pdfs\converted_#arguments.SVGName#.pdf";
				}
			</cfscript>
		<cfcatch type="any">
			<cfthrow message="#cfcatch.message# #cfcatch.detail# #BatikParams#">
		</cfcatch>	
		</cftry>		

		<cfif fileExists(PDFFile)>
			<cfset blnSuccess = true>
		</cfif>
		
		<cfreturn blnSuccess />
	</cffunction>

	<cffunction name="convertToTIF" displayname="Save Banner" hint="Saves a TIFF" access="remote" output="false" returntype="boolean">
		<cfargument name="SVGName" type="string" required="true" />
		<cfscript>
			var blnSuccess = false;
			var BatikParams = "";
			var TifFile = "";
			var sIP = getVisitorIP();
			if (sIP neq "127.0.0.1") {
				BatikParams = "D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\converted_svgs\converted_#arguments.SVGName#.svg -d D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\converted_tifs\converted_#arguments.SVGName#.tif";
			} else {
				BatikParams = "C:\inetpub\wwwroot\flextraining\ImageToPDF\converted_svgs\converted_#arguments.SVGName#.svg -d C:\inetpub\wwwroot\flextraining\ImageToPDF\converted_tifs\converted_#arguments.SVGName#.tif";
			}			
		</cfscript>
		
		<!--- convert the SVG to a TIFF --->
		<cftry>
			<cfscript>
				myObject = createObject("java", "java.lang.Runtime").getRuntime();
				if (sIP neq "127.0.0.1") {
					myObject.exec("D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\batik-1.7\jre\bin\java -jar D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\batik-1.7\batik-rasterizer.jar " & BatikParams & " -m image/tiff");
				} else {
					myObject.exec("C:\inetpub\wwwroot\flextraining\ImageToPDF\batik-1.7\jre\bin\java -jar C:\inetpub\wwwroot\flextraining\ImageToPDF\batik-1.7\batik-rasterizer.jar " & BatikParams & " -m image/tiff");
				}
				// sleep 4 seconds
				thread = CreateObject("java", "java.lang.Thread");
				thread.sleep(4000);
				if (sIP neq "127.0.0.1") {
					TifFile = "D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\converted_tifs\converted_#arguments.SVGName#.tif";
				} else {
					TifFile = "C:\inetpub\wwwroot\flextraining\ImageToPDF\converted_tifs\converted_#arguments.SVGName#.tif";
				}
			</cfscript>
		<cfcatch type="any">
			<cfthrow message="#cfcatch.message# #cfcatch.detail# #BatikParams#">
		</cfcatch>	
		</cftry>		

		<cfif fileExists(TifFile)>
			<cfset blnSuccess = true>
		</cfif>

		<cfreturn blnSuccess />
	</cffunction>

	<cffunction name="zipUp" displayname="Zip Up" hint="Creates a Zip Archive of the PNG, SVG and PDF files" access="remote" output="false" returntype="boolean">
		<cfargument name="PNGName" type="string" required="true" />
		<cfset var blnZipSuccess = false>
		<cfset var ZipFile = "">
		<cftry>
			<!--- add png to zip archive --->
			<cfzip action="zip" source="#ExpandPath('../../../converted_pngs/converted_#arguments.PNGName#.png')#" file="#ExpandPath('../../../multipleformats_zips/converted_#arguments.PNGName#.zip')#" overwrite="true"/>
			<!--- add svg to zip archive --->
			<cfzip action="zip" source="#ExpandPath('../../../converted_svgs/converted_#arguments.PNGName#.svg')#" file="#ExpandPath('../../../multipleformats_zips/converted_#arguments.PNGName#.zip')#"/>
			<!--- add pdf to zip archive --->
			<cfzip action="zip" source="#ExpandPath('../../../converted_pdfs/converted_#arguments.PNGName#.pdf')#" file="#ExpandPath('../../../multipleformats_zips/converted_#arguments.PNGName#.zip')#"/>
			<!--- add tif to zip archive --->
			<cfzip action="zip" source="#ExpandPath('../../../converted_tifs/converted_#arguments.PNGName#.tif')#" file="#ExpandPath('../../../multipleformats_zips/converted_#arguments.PNGName#.zip')#"/>
			<!--- Sleep 4 seconds --->
			<cfset thread = CreateObject("java", "java.lang.Thread")>
			<cfset thread.sleep(4000)>
			<cfset ZipFile = "#ExpandPath('../../../multipleformats_zips/converted_#arguments.PNGName#.zip')#">	
		<cfcatch type="any">
			<cfthrow message="#cfcatch.message# #cfcatch.detail#">
		</cfcatch>	
		</cftry>		

		<cfif fileExists(ZipFile)>
			<cfset blnZipSuccess = true>
		</cfif>

		<cfreturn blnZipSuccess />
	</cffunction>

	<cffunction name="cleanUp" displayname="Clean Up" hint="Deletes TIF, PDF, and SVG files" access="remote" output="false" returntype="boolean">
		<cfargument name="PNGName" type="string" required="true" />
		<cfset var blnDeleteSuccess = false>
		<cftry>
			<cfscript>
				var sIP = getVisitorIP();
				var pngFileToDelete = "";
				var svgFileToDelete = "";
				if (sIP neq "127.0.0.1") {
					pdfFileToDelete = "D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\converted_pdfs\converted_#arguments.PNGName#.pdf";
					svgFileToDelete = "D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\converted_svgs\converted_#arguments.PNGName#.svg";
					tifFileToDelete = "D:\home\webhtml5.info\wwwroot\flextraining\ImageToPDF\converted_tifs\converted_#arguments.PNGName#.tif";
				} else {
					pdfFileToDelete = "C:\inetpub\wwwroot\flextraining\ImageToPDF\converted_pdfs\converted_#arguments.PNGName#.pdf";
					svgFileToDelete = "C:\inetpub\wwwroot\flextraining\ImageToPDF\converted_svgs\converted_#arguments.PNGName#.svg";
					tifFileToDelete = "C:\inetpub\wwwroot\flextraining\ImageToPDF\converted_tifs\converted_#arguments.PNGName#.tif";
				}
			</cfscript>
			<cfif FileExists(#pdfFileToDelete#)>
				<!--- delete pdf --->
				<cffile action="delete" file="#pdfFileToDelete#">
			</cfif>
			<cfif FileExists(#svgFileToDelete#)>
				<!--- delete svg --->
				<cffile action="delete" file="#svgFileToDelete#">
			</cfif>
			<cfif FileExists(#tifFileToDelete#)>
				<!--- delete tif --->
				<cffile action="delete" file="#tifFileToDelete#">
			</cfif>

			<cfset blnDeleteSuccess = true>
		<cfcatch type="any">
			<cfthrow message="#cfcatch.message# #cfcatch.detail#">
		</cfcatch>	
		</cftry>		

		<cfreturn blnDeleteSuccess />
	</cffunction>

</cfcomponent>