
<%@page import="java.util.ArrayList"%>
<html>
    <head>       
        <title>JSP Page</title>
        <style>
            body{
                background-color: black;
                font: 20px verdana;
                color: white;
                display: flex;
                flex-direction: column;
                justify-content:center;
                align-items:center;
                width:95%;
                height:95%
            }
            #movieList,#theatreTemplate,#theatreContent,#seatList,#ticket,#HistoryContent,#dateList,#displayShow{
                display:none;
            }
            #logoutBtn{
                width:1000px;
                margin-left:100px;
            }
            #logoutBn,#bookedTicketList{
                margin-left:950px;
            }
            button{
                margin:10px;
            }
            .seatField{
                background-color: yellow;
                border: 1px solid white;
                color: black;
                padding: 8px 10px;
                margin: 5px;
                text-align: center;
            }
            table, th, td {
                border: 1px solid white;
            }
            th, td {
                padding: 2px;
                text-align: center;
            }
            th {
                background-color: white;
                color: black;
            }          
            #cityClientError,#movieClientError,#theatreClientError,#dateClientError,#showClientError,#seatClientError{
               font-size:20px;
               width:auto;
               background-color:red;
            }
 
        </style>
    </head>
    <body onload="loaded()">    
        <div id="logoutBtn">
            <button id="logoutBn" onclick="logout()">LOGOUT</button>
            <button id="bookedTicketList" onclick="showMyHistory()">MYHISTORY</button>
        </div>                                      
        <div id="main">         
            <div id="cityList">                
                <%

                    if (session.getAttribute("mail") == null) {
                        response.sendRedirect("/application1");
                    }
                    String mail = (String) session.getAttribute("mail");
                %>
                <h1>Hello <%= mail%></h1>  
                <div id="displayCity">
                </div>     
                <h2 id="cityClientError"></h2>
                <button onclick="getMovie()">CONFIRM</button><br>
            </div>
            <br>

            <div id="movieList"> 
                <h4>--SELECT THE MOVIE--</h4>
                <div id="displayMovie"></div>
                <h2 id="movieClientError"></h2>
                <button onclick="getFollowingDates()">CONFIRM</button></br>                
                <button onclick="loaded()">BACK</button><br>
            </div>

            <div id="dateList">
                <h4>--SELECT THE DATE--</h4>
                <div id="displayDate"></div>
                <h2 id="dateClientError"></h2>
                <button onclick="getTheatre()">CONFIRM</button>
                <button onclick="getMovie()">BACK</button><br>
            </div>
            <div id="theatreTemplate">               
                <table>
                    <tr id="contentTheatreRow">
                        <td id="serialNum"></td>
                        <td id="theatreName"></td>
                        <td id="movieName"></td>
                    </tr>   
                </table>                  
            </div>

            <div id="theatreContent">
                <h4>--SELECT THE THEATRE--</h4>
                <table>
                    <tr>
                        <th>S.NO</th>
                        <th>THEATRE-NAME</th>
                        <th>MOVIE-NAME</th>
                        <th>CHOOSE</th>
                    </tr>
                    <tbody id="theatreTable"></tbody> 
                    <h2 id="theatreClientError"></h2>        
                </table>
                <button onclick="getFollowingDates()">BACK</button><br>               
            </div>
            <div id="displayShow">
                <h4>--PICK THE SHOW :) --</h4>
                <div id="showList"></div>   
                 <h2 id="showClientError"></h2>
                <button onclick="selectedTheatre()">BOOK</button>         
                <button onclick="getTheatre()">BACK</button>         
            </div>
            <div id="seatList">
                <h4>--SELECT THE SEATS--</h4>
                 <h3 id="seatClientError"></h3>
                <div id="displaySeat"></div>
                <button onclick="bookTicket()">BOOK</button>                
            </div>
            <div id="ticket">
                <h2>--TICKET--</h2>
                <div id="ticketList"></div>
                <button onclick="backToHome()">HOME</button>
            </div>

            <div id="HistoryContent">
                <h4 style="margin-left:10px">--MY HISTORY--</h4>
                <div style="height: 300px; overflow: auto">
                    <table id="historyList">
                    <thead>
                        <tr>
                        <th>S.NO</th>
                        <th>CITY-NAME</th>
                        <th>MOVIE-NAME</th>
                        <th>THEATRE-NAME</th>
                        <th>SEAT-NUMBERS</th>
                        <th>FARE</th>
                        <th>SHOW-DATE</th>
                        <th>SHOW-TIME</th>
                        <th>BOOKED-DATE</th>
                        </tr>
                    </thead>
                    <tbody id="myHistorY"  style="height: 350px;"></tbody>            
                   </table>
                </div>
                <button onclick="backToHomeMyHistory()">HOME</button>
            </div>
    </body>
    <script>
        const logout = () => {
            location.href = "logout";
        }

        var currCity;
        var cityId;
        const loaded = () => {
            document.getElementById("movieList").style.display = "none";
            document.getElementById("cityList").style.display = "block";
            document.getElementById("bookedTicketList").style.display = "block";
            const http = new XMLHttpRequest();
            http.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200)
                {
                    console.log(this.responseText);
                    const city = JSON.parse(this.responseText);

                    const parent = document.getElementById("displayCity");
                    const form = document.createElement("form");
                    
                    if (parent.childNodes[1] !== undefined){
                       return;
                    }
                        
                    for (i = 0; i < city.length; i++)
                    {
                        var child = document.createElement("div");

                        var radiobox = document.createElement('input');
                        radiobox.type = 'radio';
                        radiobox.name = 'city';
                        radiobox.id=city[i]["cityId"];
                        radiobox.value = city[i]["city"];

                        var label = document.createElement('label');
                        label.innerHTML = city[i]["city"];
                        
                        label.appendChild(radiobox);
                        child.appendChild(label);

                        parent.appendChild(child);
                    }
                    
                } else if (this.readyState == 4 && this.status == 401)
                {
                    location.href = "application1";
                }
            }

            http.open("GET", "cities", false);
            http.send();
        }

        const getMovie = () => {
            var radios = document.getElementsByName("city");
            let selected = Array.from(radios).find(radio => radio.checked);
            document.getElementById("cityClientError").innerHTML = "";
            document.getElementById("movieClientError").innerHTML = "";
            if (selected === undefined) {
                document.getElementById("cityClientError").innerHTML ="NO FIELDS IS SELECTED";
                return;
            }
            console.log(selected.id);
            currCity = selected.value;
            cityId= selected.id;
            let parent = document.getElementById("displayMovie");
            parent.innerHTML = "";
            document.getElementById("cityClientError").innerHTML = "";
            document.getElementById("movieClientError").innerHTML = "";
            
            const http = new XMLHttpRequest();
            http.onreadystatechange = function ()
            {

                if (this.readyState == 4 && this.status == 200)
                {                         
                    let parent = document.getElementById("displayMovie");
                    parent.innerHTML = "";      
                    document.getElementById("cityList").style.display = "none";
                    document.getElementById("dateList").style.display = "none";
                    document.getElementById("movieList").style.display = "block";
                    document.getElementById("theatreContent").style.display = "none";
                    document.getElementById("bookedTicketList").style.display = "none";
                    let movies = JSON.parse(this.responseText);

                    for (i = 0; i < movies.length; i++)
                    {
                        var child = document.createElement("div");

                        var label = document.createElement('label');
                        label.innerHTML = movies[i]["movie"];
                        
                        var radiobox = document.createElement('input');
                        radiobox.type = 'radio';
                        radiobox.name = 'movie';
                        radiobox.value = movies[i]["movie"];
                        radiobox.id = movies[i]["movieId"];

                        label.append(radiobox);
                       // child.appendChild(radiobox);
                        child.appendChild(label);
     
                        parent.appendChild(child);   
                    }
                } 
                else if(this.readyState==4 && this.status==204 ){               
                    document.getElementById("cityList").style.display = "none";
                    document.getElementById("movieList").style.display = "block";
                    document.getElementById("theatreContent").style.display = "none";
                    document.getElementById("bookedTicketList").style.display = "none";
                    let movies = this.responseText;
                    let displayMessage= document.createElement("h3");
                    displayMessage.innerHTML="NO MOVIES FOUND";
                    displayMessage.style.backgroundColor='green';
                    parent.appendChild(displayMessage);   
                }else if (this.readyState == 4 && this.status == 401)
                {
                    document.getElementById("cityClientError").innerHTML = this.responseText;
                } else if (this.readyState == 4 && this.status == 400)
                {
                     location.href = "/application1";
                }
            }
            let data = 'movies?cityId=' + cityId;
            http.open("GET", data, false);
            http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            http.send(data);
        }
        var theatreList;
        var currTheatre;
        var currMovie;
        var currDate;
        var currShow;
        var shows;
        var prevBookedSeat=[];
        
        var movieId;
        var theatreId;
        var dateId;
        
        const getTheatre = () => {
            var radios = document.getElementsByName("date");
            var selected = Array.from(radios).find(radio => radio.checked);
            document.getElementById("theatreClientError").innerHTML = "";
            if (selected === undefined) {
                document.getElementById("dateClientError").innerHTML = "NO FIELDS IS SELECTED";
                return;
            }
            currDate = selected.value;
            dateId=selected.id;
            console.log(selected.id);
            const http = new XMLHttpRequest();
            var data = 'theatres?city=' + cityId + '&movie=' + movieId + '&date=' + dateId;
            console.log(data);
            http.onreadystatechange = function ()
            {
                if (this.readyState == 4 && this.status === 200)
                {

                    let theatre = JSON.parse(this.responseText);
                    console.log(theatre);
                    theatreList = theatre;
                    document.getElementById("dateList").style.display = "none";
                    document.getElementById("displayShow").style.display = "none";
                    document.getElementById("theatreContent").style.display = "block";
                    document.getElementById("theatreClientError").innerHTML = "";
                    let tbody = document.getElementById("theatreTable");
                    tbody.innerHTML = "";
                    let row = document.getElementById("contentTheatreRow");
                    for (i = 0; i < theatre.length; i++)
                    {
                        let clone = row.cloneNode(true);

                        let serialNum = clone.children[0];
                        let theatreName = clone.children[1];
                        let movieName = clone.children[2];
                        let button = clone.children[3];

                        serialNum.innerHTML = (i + 1);
                        theatreName.innerHTML = theatre[i]["theatreName"];
                        movieName.innerHTML = currMovie;

                        let btn = document.createElement("button");
                        btn.id = theatre[i]["theatreId"];
                        btn.idxId=i;
                        btn.innerHTML = "CLICK";
                        btn.onclick = function () {
                            getShow(this);
                        }

                        clone.appendChild(btn,0);
                        tbody.appendChild(clone);

                    }
                } else if (this.readyState == 4 && this.status == 401) {
                    document.getElementById("dateClientError").innerHTML = this.responseText;
                } else if (this.readyState == 4 && this.status == 400)
                {
                     location.href = "/application1";
                } else if(this.readyState==4){
                    console.log(this.status);
                    document.getElementById("dateList").style.display = "none";
                    document.getElementById("theatreContent").style.display = "block";
                    document.getElementById("theatreClientError").innerHTML = "";
                    
                    document.getElementById("theatreClientError").innerHTML = "NO THEATRE FOUND";
                }
            }
            http.open("GET", data, true);
            http.send();
        }

        var bookedTheatre;
        let bookedSeat = [];

        const getShow = (btn) => {
            bookedTheatre = btn.id;
            const http = new XMLHttpRequest();
            http.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200)
                {
                    let parent = document.getElementById("showList");
                    parent.innerHTML = "";
                    document.getElementById("showClientError").innerHTML ="";
                    document.getElementById("seatClientError").innerHTML="";
                    document.getElementById("displayShow").style.display = "block";
                    document.getElementById("theatreContent").style.display = "none";
                    document.getElementById("seatList").style.display = "none";
                    //currTheatre = theatreList[btn.id]["theatreName"];
                    theatreId = bookedTheatre;
                    console.log(theatreId);
                    for(i=0;i<theatreList.length;i++)
                    {
                        if(theatreId==theatreList[i]["theatreId"]){
                             currTheatre=theatreList[i]["theatreName"];
                             break;
                        }
                    }
                    
                    
                    var show = JSON.parse(this.responseText);
                    shows = JSON.parse(this.responseText);

                    console.log(show);
                    for (i = 0; i < show.length; i++)
                    {
                        var child = document.createElement("div");

                        var radiobox = document.createElement('input');
                        radiobox.type = 'radio';
                        radiobox.name = 'show';
                        radiobox.id = show[i]["showId"];
                        radiobox.value = show[i]["showTime"];

                        var label = document.createElement('label');
                        label.innerHTML = show[i]["showTime"];

                        label.appendChild(radiobox);
                        child.appendChild(label);
                        child.style.padding = "10px";

                        parent.appendChild(child);
                        parent.appendChild(child);
                    }
                    console.log(parent);
                } else if (this.readyState == 4 && this.status == 401) {
                    document.getElementById("theatreClientError").innerHTML = this.responseText;
                }else if (this.readyState == 4 && this.status == 400)
                {
                     location.href = "/application1";
                }
            }
            var data = "shows?city=" + cityId + "&movie=" + movieId + "&theatreId=" + bookedTheatre;
            http.open("GET", data, false);
            http.send();
        }
        
        const selectedTheatre = () => {
            var radios = document.getElementsByName("show");
            document.getElementById("showClientError").innerHTML="NO FIELD IS SELECTED";
            var selected = Array.from(radios).find(radio => radio.checked);
            if (selected === undefined) {
                document.getElementById("showClientError").innerHTML="NO FIELDS IS SELECTED";
                return;
            }
            
            showId = selected.id;
            
            const http = new XMLHttpRequest();

            http.onreadystatechange = function ()
            {
                if (this.readyState === 4 && this.status == 200)
                {
                    

            bookedSeat = [];
            document.getElementById("seatList").style.display = "block";
            document.getElementById("displayShow").style.display = "none";

            let seat = document.getElementById("displaySeat");
            seat.innerHTML = "";
                   //  prevBookedSeat = shows[currShow.id]["bookedSeat"];
                     for(i=0;i<shows.length;i++){
                          if(shows[i]["showId"]==showId){
                               prevBookedSeat=shows[i]["bookedSeat"];
                               break;
                          }
                     }
                     console.log(prevBookedSeat);
                    for (i = 1; i <= 50; i++)
                    {
                        let btn = document.createElement("button");
                        btn.id = i;
                        btn.className = "seatField";
                        btn.innerHTML = i;

                        btn.onclick = function () {
                            selectedSeat(this, btn.id);
                        }

                        if (prevBookedSeat.find((val) => val === i) != undefined)
                        {
                            btn.innerHTML = 'B';
                            btn.style.backgroundColor = "black";
                            btn.style.color = "white";
                            btn.style.border = "1px solid white";
                            btn.disabled = true;
                        }
                        seat.appendChild(btn);
                        if (i % 10 == 0) {
                            var br = document.createElement("br");
                            seat.appendChild(br);
                        }
                       console.log(btn);
                    }
                }else if (this.readyState == 4 && this.status == 401) {
                    document.getElementById("showClientError").innerHTML = this.responseText;
                }else if (this.readyState == 4 && this.status == 400)
                {
                     location.href = "/application1";
                }

            }
            http.open("POST", "seat");
            http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            http.send("city=" + cityId + "&movie=" + movieId + "&theatreId=" + theatreId + "&showId=" + showId);

        }


        const selectedSeat = (btn, n) => {
            console.log(btn.id+" "+n);
            let seat = document.getElementById(btn.id);
            console.log(seat.id + "--------");
            
  console.log(seat.style.backgroundColor);
            
            if (seat.style.backgroundColor == "black")
            {
                
                seat.style.backgroundColor = "yellow";
                seat.style.color = "black";
                seat.style.border = "1px solid white";
                bookedSeat = bookedSeat.filter((val) => val != n);
            } else {
                seat.style.backgroundColor = "black";
                seat.style.color = "white";
                seat.style.border = "1px solid white";
                bookedSeat.push(n);
            }
            console.log(bookedSeat);
        }

        var currTicket;
        var bookedSeatNumbers = [];
        const bookTicket = () => {
         document.getElementById("seatClientError").innerHTML="";
            if (bookedSeat.length == 0) {
               document.getElementById("seatClientError").innerHTML="NO SEAT IS SELECTED";

                return;
            }
            const http = new XMLHttpRequest();

            http.onreadystatechange = function ()
            {
                if (this.readyState === 4 && this.status == 200)
                {
                    document.getElementById("seatList").style.display = "none";
                    document.getElementById("ticket").style.display = "block";
                    addTicket();
                }
                if (this.status === 401 && this.readyState == 4)
                {
                
                    document.getElementById("seatClientError").innerHTML="Seat " + this.responseText + " is already Booked !!!";
                } else if (this.readyState == 4 && this.status == 400) {
                    location.href = "/application1";
                }
            }
            bookedSeatNumbers = [];
            for (i in bookedSeat)
            {
                bookedSeatNumbers.push(bookedSeat[i].id);

            }

            http.open("POST", "addseat");
            http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            http.send("city=" + cityId + "&movie=" + movieId + "&date=" + dateId + "&theatreId=" + theatreId + "&bookedSeat=" + bookedSeat + "&showId=" + showId);
        }

        const addTicket = () => {
            const http = new XMLHttpRequest();
      /*      currTicket = {
                city: currCity,
                movie: currMovie,
                theatre: currTheatre,
                seat: bookedSeat
            };   */
            
            http.onreadystatechange = function ()
            {
                if (this.readyState == 4 && this.status == 200)
                {
                    let ticket = document.getElementById("ticketList");
                    ticket.innerHTML = "";
                    let city = document.createElement("h4");
                    city.innerHTML = currCity;
                    let movie = document.createElement("h4");
                    movie.innerHTML = currMovie;
                    let theatre = document.createElement("h4");
                    theatre.innerHTML = currTheatre;
                    let seat = document.createElement("h4");
                    seat.innerHTML = bookedSeat;

                    ticket.appendChild(city);
                    ticket.appendChild(movie);
                    ticket.appendChild(theatre);
                    ticket.appendChild(seat);
                } else if (this.readyState == 4 && this.status == 401) {
                    location.href = "/application1/home";
                }else if (this.readyState == 4 && this.status == 400)
                {
                     location.href = "/application1";
                }
            }
            http.open("POST", "addticket");
            http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
           /* let dataTicket = {
                city: currCity,
                movie: currMovie,
                theatreName: currTheatre,
                bookedSeat: bookedSeat,
                bookedDate: currDate,
                showTime: currShow.value
            }   */
        
            http.send("bookedSeat=" + bookedSeat + "&dateId=" + dateId + "&showId=" + showId);
        }

        const backToHome = () => {
            location.href = "/application1/home";
        }

        const backToHomeMyHistory = () => {
            location.href = "/application1/home";
        }
        const showMyHistory = () => {
             document.getElementById("seatClientError").innerHTML="";
            document.getElementById("cityList").style.display = "none";
            document.getElementById("HistoryContent").style.display = "inline-block";
            const http = new XMLHttpRequest();
            document.getElementById("cityList").style.display = "none";

            http.onreadystatechange = function () {

                if (this.readyState == 4 && this.status == 200)
                {
                    let myHistory = JSON.parse(this.responseText);
                    let tbodY = document.getElementById('myHistorY');
                    tbodY.innerHTML = "";
                    console.log(myHistory[0]["city"]);
                    for (i = 0; i < myHistory.length; i++)
                    {
                        let roW = document.createElement("tr");

                        let sNO = document.createElement("td");
                        let citY = document.createElement("td");
                        let moviE = document.createElement("td");
                        let theatrE = document.createElement("td");
                        let seaT = document.createElement("td");
                        let farE = document.createElement("td");
                        let bookedDate = document.createElement("td");
                        let showTime = document.createElement("td");
                        let datE = document.createElement("td");

                        sNO.innerHTML = i + 1;
                        citY.innerHTML = myHistory[i]["city"];
                        moviE.innerHTML = myHistory[i]["movie"];
                        theatrE.innerHTML = myHistory[i]["theatre"];
                        seaT.innerHTML = myHistory[i]["seat"];
                        farE.innerHTML = myHistory[i]["fare"];
                        bookedDate.innerHTML = myHistory[i]["bookedDate"];
                        showTime.innerHTML = myHistory[i]["showTime"];
                        datE.innerHTML = myHistory[i]["date"];

                        roW.appendChild(sNO);
                        roW.appendChild(citY);
                        roW.appendChild(moviE);
                        roW.appendChild(theatrE);
                        roW.appendChild(seaT);
                        roW.appendChild(farE);
                        roW.appendChild(bookedDate);
                        roW.appendChild(showTime);
                        roW.appendChild(datE);

                        tbodY.appendChild(roW);

                    }
                }else if (this.readyState == 4 && this.status == 400)
                {               
                     location.href = "/application1";
                }

            }

            http.open("GET", "tickets", false);
            http.send();
        }
        const getFollowingDates = () => {
            var radios = document.getElementsByName("movie");
            var selected = Array.from(radios).find(radio => radio.checked);
            document.getElementById("movieClientError").innerHTML="";
            if (selected === undefined) {
                document.getElementById("movieClientError").innerHTML="NO FIELDS IS SELECTED";
                return;
            }

            currMovie = selected.value;
            movieId = selected.id;
            
            const http = new XMLHttpRequest();
            http.onreadystatechange = function () {
                if (this.status == 200 && this.readyState == 4)
                {
                    document.getElementById("theatreContent").style.display = "none";
                    document.getElementById("theatreClientError").innerHTML = "";
                    document.getElementById("movieList").style.display = "none";
                    document.getElementById("dateList").style.display = "block";
                    document.getElementById("dateList").style.alignItems = "center";
                    document.getElementById("dateClientError").innerHTML = "";

                    let date = JSON.parse(this.responseText);
                    let div = document.getElementById("displayDate");
                    div.innerHTML = "";
                    for (i = 0; i < date.length; i++)
                    {
                        var child = document.createElement("div");

                        var radiobox = document.createElement('input');
                        radiobox.type = 'radio';
                        radiobox.name = 'date';
                        radiobox.value = date[i]["date" + (i + 1)];
                        radiobox.id=date[i]["dateId"];

                        var label = document.createElement('label');
                        label.innerHTML = date[i]["date" + (i + 1)];

                        label.appendChild(radiobox);
                        child.appendChild(label);
                        child.style.padding = "10px";
                        div.appendChild(child);
                        console.log(date);
                    }
                } else if (this.readyState == 4 && this.status == 401) {
                    document.getElementById("movieClientError").innerHTML = this.responseText;
                }else if (this.readyState == 4 && this.status == 400)
                {
                     location.href = "/application1";
                }
            }
            http.open("GET", "bookingDates?city=" + cityId + "&movie=" + movieId, false);
            http.send();
        }
    </script>
</html>

