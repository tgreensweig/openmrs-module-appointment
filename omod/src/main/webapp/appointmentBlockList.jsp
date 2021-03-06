<%@ include file="/WEB-INF/template/include.jsp" %>
<%@ include file="/WEB-INF/template/header.jsp" %>
<%@ include file="localHeader.jsp" %>
<openmrs:htmlInclude file="/scripts/timepicker/timepicker.js" />
<openmrs:htmlInclude file="/moduleResources/appointment/createAppointmentStyle.css"/>
<openmrs:htmlInclude file="/scripts/jquery/jsTree/jquery.tree.min.js" />
<openmrs:htmlInclude file="/scripts/jquery/jsTree/themes/classic/style.css" />
<openmrs:htmlInclude file="/scripts/jquery/dataTables/css/dataTables.css" />
<openmrs:htmlInclude file="/scripts/jquery/dataTables/js/jquery.dataTables.min.js" />
 <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script type="text/javascript" src='${pageContext.request.contextPath}/dwr/engine.js'></script>
<script type="text/javascript" src='${pageContext.request.contextPath}/dwr/util.js'></script>
<script type="text/javascript" src='${pageContext.request.contextPath}/dwr/interface/DWRAppointmentService.js'></script>
<script type="text/javascript">
		function updateHrefForAppointmentBlockEdit()
		{
			var appointmentBlockId = getSelectedAppointmentBlockId();
			if(appointmentBlockId!=null){
				document.getElementById("editLink").href="appointmentBlockForm.form?appointmentBlockId="+appointmentBlockId;			
			}
			else
			{
				window.alert('<openmrs:message code="appointment.AppointmentBlock.error.selectAppointmentBlock" javaScriptEscape="true"/>');	
			}
		}
		function getSelectedAppointmentBlockId()
		{
			var radios = document.getElementsByName('appointmentBlockRadios');
			var appointmentBlockId;
			for (var i = 0; i < radios.length; i++) {
			    if (radios[i].type === 'radio' && radios[i].checked) {
			        // get value, set checked flag or do whatever you need to
			        appointmentBlockId = radios[i].value;     
			        break;
			    }
			}
			return appointmentBlockId;
		}
		function deleteSelectedAppointmentBlock()
		{
			var appointmentBlockId = getSelectedAppointmentBlockId();
			if(appointmentBlockId != null)
			{
				DWRAppointmentService.purgeAppointmentBlock(appointmentBlockId, function(){
					updateAppointmentBlockTable();
				});
			}
			else{
				window.alert('<openmrs:message code="appointment.AppointmentBlock.error.selectAppointmentBlock" javaScriptEscape="true"/>');
			}
		}
        function updateAppointmentBlockTable()
        {
                        var selectedDate = document.getElementById('dateFilter').value;
	                    var selectedLocation = document.getElementById("locationId");
		                var locationId = selectedLocation.options[selectedLocation.selectedIndex].value;	           
                        var tableContent = '';
                        document.getElementById('appointmentBlocksTable').innerHTML = tableContent;
                        tableContent="<tr>";
                        tableContent+='<th align="center"><spring:message code="appointment.AppointmentBlock.column.select"/></th>';
                        tableContent+='<th align="center"> <spring:message code="appointment.AppointmentBlock.column.location"/> </th>';
                        tableContent+='<th align="center"> <spring:message code="appointment.AppointmentBlock.column.user"/> </th>';
                        tableContent+='<th align="center"> <spring:message code="appointment.AppointmentBlock.column.appointmentTypes"/> </th>';
                        tableContent+='<th align="center"> <spring:message code="appointment.AppointmentBlock.column.startTime"/> </th>';
                        tableContent+='<th align="center"> <spring:message code="appointment.AppointmentBlock.column.endTime"/> </th>';
                        tableContent+="</tr>";
	           			document.getElementById('appointmentBlocksTable').innerHTML +=tableContent;
                        DWRAppointmentService.getAppointmentBlocks(selectedDate,locationId,function(appointmentBlocks){
		    				    tableContent = '';
                                for(var i=0;i<appointmentBlocks.length;i++)
                                {
                                    tableContent = "<tr>";
                                    tableContent += '<td align="center">'+'<input type="radio" name="appointmentBlockRadios" value="'+appointmentBlocks[i].appointmentBlockId+'"/></td>';
                                    tableContent += '<td align="center">'+appointmentBlocks[i].location.name+"</td>";      
                                    tableContent += '<td align="center">'+appointmentBlocks[i].provider.name+"</td>";
                                    //Linking the appointment types in a string.
                                    var appointmentTypes = "";
                                    var appointmentTypesArray = appointmentBlocks[i].types;
                                    for(var j=0;j<appointmentTypesArray.length;j++)
                                    {
                                    	    appointmentTypes += appointmentTypesArray[j].name;
                                    		if(j<(appointmentTypesArray.length - 1)){
                                    			appointmentTypes += ", ";
                                    		}
                                    }

                                    tableContent += '<td align="center">'+appointmentTypes+"</td>";    
		       					    tableContent += '<td align="center">'+appointmentBlocks[i].startDate.toString()+'</td>';
    		     			        tableContent += '<td align="center">'+appointmentBlocks[i].endDate.toString()+'</td>';
                                    tableContent += "</tr>";
                                    document.getElementById('appointmentBlocksTable').innerHTML += tableContent;
		      				   }                   
							   
                       });
                        
        }
       
        //Showing the jQuery data table when the page loaded.
         $j(document).ready(function() {
                updateAppointmentBlockTable();
        });
 
</script>
<h2><spring:message code="appointment.AppointmentBlock.manage.title"/></h2>
<br/><br/>
 
<fieldset style="clear: both">
        <legend><spring:message code="appointment.AppointmentBlock.legend.properties"/></legend>
        <div style="margin: 0.5em 0;">
                        <table>
                                        <tr>
                                                <td><spring:message code="appointment.AppointmentBlock.pickDate"/>: </td>
                                                <td><input type="text" name="Date" id="dateFilter" size="16" value="" onfocus="showDateTimePicker(this)"/><img src="${pageContext.request.contextPath}/moduleResources/appointment/calendarIcon.png" class="calendarIcon" alt="" onClick="document.getElementById('dateFilter').focus();"/></td>
                                        </tr>
                                        <tr>
                                            <td><spring:message code="appointment.AppointmentBlock.column.location"/>: </td>
				<td><openmrs:fieldGen type="org.openmrs.Location" formFieldName="locationId" val="${selectedLocation}" /></td>
                                        </tr>
                                        <tr>
                                                <td><input type="button" value="Apply" onClick="updateAppointmentBlockTable()"></td>
                                        </tr>
                                </table>
        </div>
</fieldset>
 
<br/>
<b class="boxHeader"><spring:message code="appointment.AppointmentBlock.list.title"/></b>
<form method="post" class="box">
        <table id="appointmentBlocksTable">
 
 
        </table>
</form>
<table align="center">
        <tr><td><a href="appointmentBlockForm.form"><spring:message code="appointment.AppointmentBlock.add"/></a></td>
        <td><a id="editLink" onClick="updateHrefForAppointmentBlockEdit()"  ><spring:message code="appointment.AppointmentBlock.edit"/></a></td>
        <td><a onClick="deleteSelectedAppointmentBlock()"><spring:message code="appointment.AppointmentBlock.delete"/></a></td>
        </tr>
</table>
 
 
 
<%@ include file="/WEB-INF/template/footer.jsp" %>