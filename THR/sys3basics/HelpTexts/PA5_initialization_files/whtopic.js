//FlashHelp 1.0

var gaPaths = new Array();
var gaAvenues = new Array();
var gnTopicOnly = -1;

var gsPPath = "";
var gsStartPage = "";
var gsRelCurPagePath = "";
var gsTopicbarOrder="";

var gstrBsAgent 	= navigator.userAgent.toLowerCase();
var gnBsVer	   		= parseInt(navigator.appVersion);
var gbBsIE  		= (gstrBsAgent.indexOf('msie') != -1);
var gbBsNS  		= (gstrBsAgent.indexOf('mozilla') != -1) && ((gstrBsAgent.indexOf('spoofer') == -1) && (gstrBsAgent.indexOf('compatible') == -1));
var gbBsOpera		= (gstrBsAgent.indexOf('opera') != -1);
var gbBsNS4			= ((gbBsNS) && (gnBsVer >= 4));
var gbBsNS6			= ((gbBsNS) && (gnBsVer >= 5));

function SendCmdToMainHTML(cmd, param) {
	if( (parent != this) && (parent.DoCommand) )
	{
		parent.DoCommand(cmd, param);	
	}
}

function sendTopicLoaded()
{
	parent.gbTopicLoaded = true;
	SendCmdToMainHTML("CmdTopicIsLoaded",1);
}

function DoCommand(cmd, param) {
	if (cmd == "CmdAskIsTopicOnly")	{
		if( (parent!=this) && (parent.DoCommand) )
		{
			parent.DoCommand(cmd, param);	
		}
	} else if (cmd == "CmdScrollbarDragStart") {
		if (gbBsNS6 || gbBsOpera) {
			document.getElementById("scrollbarDIV").style.visibility = "";
		} else if (gbBsNS4) {
			document.layers["scrollbarLayer"].visibility = "show";
		}
	} else if (cmd == "CmdScrollbarDragStop") {
		if (gbBsNS6 || gbBsOpera) {
			document.getElementById("scrollbarDIV").style.visibility = "hidden";
		} else if (gbBsNS4) {
			document.layers["scrollbarLayer"].visibility = "hidden";
		}
	} else if (cmd == "CmdScrollbarDragMove") {
		if (gbBsNS6) {
			document.getElementById("scrollbarDIV").style.left = param;
		} else if (gbBsNS4) {
			document.layers["scrollbarLayer"].pageX = param;
		} else if (gbBsOpera) {
			eval('document.all.scrollbarDIV').style.pixelLeft = param;
		}
	}
}

// Unload processing
function TopicUnloaded() {
	parent.gbTopicLoaded = false;
	SendCmdToMainHTML("CmdTopicUnloaded");
}
window.onunload = TopicUnloaded;

// project info
function setRelStartPage(sPath)
{
	if (gsPPath.length == 0)
	{
		gsPPath = _getFullPath(_getPath(document.location.href),  _getPath(sPath));
		gsStartPage = _getFullPath(_getPath(document.location.href), sPath);
		gsRelCurPagePath = _getRelativeFileName(gsStartPage, document.location.href);
	}
}

function addTocInfo(sTocPath)
{
	gaPaths[gaPaths.length] = sTocPath;
}

function addAvenueInfo(sName, sPrev, sNext)
{
	gaAvenues[gaAvenues.length] = new avenueInfo(sName, sPrev, sNext);	
}

function avenueInfo(sName, sPrev, sNext)
{
	this.sName = sName;
	this.sPrev = sPrev;
	this.sNext = sNext;
}

function _getNumLines(sLines)
{
	var nLines=1;
	var nStart=0;
	while(sLines.indexOf('\n',nStart)!=-1)
	{
		nLines++;
		nStart = sLines.indexOf('\n',nStart)+1;
	}
	return nLines;
}

function stringToRGB(color_str) {
	
	// First create a lowercase version of the string
	var lowercase_str = color_str.toLowerCase();
	var value = 0xFFFFFF;
	
	if (lowercase_str.charAt(0) == "#") {
		// Convert HEX
		value = parseInt(lowercase_str.substring(1, lowercase_str.length), 16);	
	} else {
		switch (lowercase_str) {
			case "white": value = 0xFFFFFF; break;
			case "black": value = 0x000000; break;
			case "red": value = 0xFF0000; break;
			case "green": value = 0x008000; break;
			case "blue": value = 0x0000FF; break;
			case "silver": value = 0xC0C0C0; break;
			case "gray": value = 0x808080; break;
			case "maroon": value = 0x800000; break;
			case "purple": value = 0x800080; break;
			case "fuchsia": value = 0xFF00FF; break;
			case "magenta": value = 0xFF00FF; break;
			case "lime": value = 0x00FF00; break;
			case "olive": value = 0x808000; break;
			case "yellow": value = 0xFFFF00; break;
			case "navy": value = 0x000080; break;
			case "teal": value = 0x008080; break;
			case "aqua": value = 0x00FFFF; break;
			case "cyan": value = 0x00FFFF; break;
			case "brown": value = 0xA52A2A; break;
			case "darkgray": value = 0xA9A9A9; break;
			case "lightblue": value = 0xADD8E6; break;
			case "tan": value = 0xD2B48C; break;
			case "lightgray": value = 0xD3D3D3; break;
			case "beige": value = 0xF5F5DC; break;
			case "orange": value = 0xFFA500; break;
			case "gold": value = 0xFFD700; break;
		}
	}
	
	return value;
}


function sendBgColorInfo()
{
	var bgColor = 0xFFFFFF; // default to white
	if ((document.bgColor != "undefined") && (document.bgColor != "")) {
		bgColor = stringToRGB(document.bgColor);
	}
	SendCmdToMainHTML("CmdTopicBGColor", bgColor);	
}

function createSyncInfo()
{
	var sSyncInfo="";
	if (gaPaths.length <= 0)
		return "";
			
	if (gsPPath.length == 0)
		gsPPath = _getPath(document.location.href);
		
	sSyncInfo += gsPPath;
	sSyncInfo += "\n"+document.location.href;
	for(i=0;i<gaPaths.length;i++)
	{
		sSyncInfo += "\n"+ _getNumLines(gaPaths[i]) + "\n" +gaPaths[i];
	}
	return sSyncInfo;
}

function sendSyncInfo()
{	
	if (gaPaths.length <= 0)
		return;
	var sSyncInfo=createSyncInfo();	
	SendCmdToMainHTML("CmdSyncInfo",sSyncInfo);
}

function autoSync(nSync)
{
	if (nSync == 0) return;
	if (gaPaths.length <= 0)
		return;
	var sSyncInfo=createSyncInfo();	
	SendCmdToMainHTML("CmdSyncTOC",sSyncInfo);	
}


function sendAveInfo()
{	if (gaAvenues.length > 0)
		setTimeout("Do_sendAveInfo();", 100);
}

function Do_sendAveInfo()
{	
	var sAveInfo="";
	for(i=0;i<gaAvenues.length;i++)
	{
		sAveInfo+=gaAvenues[i].sName+"\n";
		sAveInfo+=gaAvenues[i].sPrev+"\n";
		sAveInfo+=gaAvenues[i].sNext;
		if(i != gaAvenues.length-1)
			sAveInfo+="\n";
	}
	SendCmdToMainHTML("CmdBrowseSequenceInfo",sAveInfo);
}

function addShowButton()
{
	if(parent.gbFHPureHtml)
		return;	
	if(isInPopup())
		return;
	if(gsTopicbarOrder.indexOf("show") <0 )
		return;
	if(!isTopicOnly())
		return;	
	var sHTML = "";
	sHTML += "<table width=100%><tr>"	
	sHTML += "<td width=33%>";
	sHTML += "<div align=left>";
	sHTML += "<table cellpadding=\"2\" cellspacing=\"0\" border=\"0\"><tr>";
	sHTML += "<td><a class=\"whtbtnshow\" href=\"javascript:void(0);\" onclick=\"show();return false;\">Show</a></td></tr></table> ";
	sHTML += "</tr></table>";
	sHTML += "</div>";
	sHTML += "</tr></table>";
	document.write(sHTML);
	var sStyle = "<style type='text/css'>";
	sStyle+= ".whtbtnshow{font-family:;font-size:10pt;font-style:;font-weight:;text-decoration:;color:;}";
	sStyle+= "</style>";
	document.write(sStyle);
}

function show()
{
	if (gsStartPage != "")
		window.location =  gsStartPage + "#" + gsRelCurPagePath;
}

function isTopicOnly()
{
	if (gnTopicOnly == 1)
		return true;
	if (gnTopicOnly == 0)
		return false;
	if (parent == this)
		return true;
	if (gnTopicOnly == -1)
	{
		var oParam = new Object();
		oParam.isTopicOnly = true;
		SendCmdToMainHTML("CmdAskIsTopicOnly",oParam);
		if (oParam.isTopicOnly)
		{		
			gnTopicOnly = 1;
			return true;
		}
		else
		{
			gnTopicOnly = 0;
			return false;
		}
	}
}

function isInPopup()
{
	return (window.name.indexOf("BSSCPopup") != -1);
}

function PickupDialog_Invoke()
{
	if (!gbIE4 || gbMac || gbOpera)
	{
		if (typeof(_PopupMenu_Invoke)=="function")
			return _PopupMenu_Invoke(PickupDialog_Invoke.arguments);
	}
	else
	{
		if (PickupDialog_Invoke.arguments.length > 2)
		{
			var sPickup = "wf_pickup.htm";
			if(sPickup.substr(0,2) == "%%")//WW: WWH_TODO delete it when release
			sPickup = "wf_pickup1.htm";
			var sPickupPath=gsPPath+sPickup; 
			if (gbIE4)
			{
				var sFrame = PickupDialog_Invoke.arguments[1];
				var aTopics = new Array();
				for (var i = 2; i< PickupDialog_Invoke.arguments.length; i+=2)
				{
					var j=aTopics.length;
					aTopics[j] = new Object();
					aTopics[j].m_sName=PickupDialog_Invoke.arguments[i];
					aTopics[j].m_sURL=PickupDialog_Invoke.arguments[i+1];
				}

				if (aTopics.length > 1)
				{
					var nWidth = 300;
					var nHeight =180;
					var	nScreenWidth=screen.width;
					var	nScreenHeight=screen.height;
					var nLeft=(nScreenWidth-nWidth)/2;
					var nTop=(nScreenHeight-nHeight)/2;
					if (gbIE4)
					{
						var vRet = window.showModalDialog(sPickupPath,aTopics,"dialogHeight:"+nHeight+"px;dialogWidth:"+nWidth+"px;resizable:yes;status:no;scroll:no;help:no;center:yes;");
						if (vRet)
						{
							var sURL = vRet.m_url;
							if (sFrame)
								window.open(sURL, sFrame);
							else
								window.open(sURL, "_self");
						}
					}
				}
				else if (aTopics.length == 1)
				{
					var sURL = 	aTopics[0].m_sURL
					if (sFrame)
						window.open(sURL, sFrame);
					else
						window.open(sURL, "_self");
				}
			}
		}
	}
}
// Add a hidden layer to simulate scrollbar dragging if this is not a browser that can handle dynamic frame resizing
if (gbBsNS6) {
	var sHTML = "<div id='scrollbarDIV' style='LEFT:10px; WIDTH:3px; POSITION:absolute; TOP:0px; HEIGHT:100%; BACKGROUND-COLOR:lightgrey; visibility:hidden; Z-INDEX:100; BORDER-WIDTH:1px; BORDER-COLOR:darkgray; BORDER-RIGHT-STYLE:solid; BORDER-LEFT-STYLE:solid;'></div>";
	document.write(sHTML);
} else if (gbBsOpera) {
	var sHTML = "<div id='scrollbarDIV' style='LEFT:10px; WIDTH:5px; POSITION:absolute; TOP:0px; HEIGHT:100%; BACKGROUND-COLOR:lightgrey; visibility:hidden; Z-INDEX:100; BORDER-WIDTH:1px; BORDER-COLOR:#A9A9A9; BORDER-RIGHT-STYLE:solid; BORDER-LEFT-STYLE:solid;'></div>";
	document.write(sHTML);
} else if (gbBsNS4) {
	var sHTML = "<layer pagex='-10' pagey='0' width='4' height='100%' name='scrollbarLayer' visibility='hidden' bgcolor='lightgrey' z-index='100'></layer>";
	document.write(sHTML);
}
