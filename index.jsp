
<html>
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
        #login,#signupDiv{
            width:500px;
            height:32S0px;
            display: flex;
            flex-direction: column;
            align-items:center;
            border: 1px solid white
        }
        #LoginInput,#signupInput{
            padding:10px;
        }
        #login,#signupDiv{
            display:none;
        }
        #signupResponse,#response{
            background-color:red;
        }
        #mainOpenDiv{
           align-items:center;
        }
        #LogSignbtnDiv{

            width:400px;
            display:flex;
            justify-content:space-evenly;
        }
    </style>
    <head>
        <title>Application1</title>
    </head>

    <body>

        <div id="mainOpenDiv">
             <h2>MOVIE TICKET-BOOKING APPLICATION</h2>
            <button onclick="main('login')" > LOGIN </button>
            <button onclick="main('signupDiv')">SIGN-UP</button>
        </div>
        
        <div id="login">
            <%
            if (session.getAttribute("mail") != null) {
            response.sendRedirect("home");
            }
            %>
            <h3>LOGIN</h3>
            <div id="LoginInput">
                <label>MAIl ID   : </label>
                <input type="text" id="loginInputMail"/> 
            </div>
            <div id="LoginInput">
                <label>PASSWORD : </label>
                <input type="password" id="loginInputPassword"/> 
            </div>
            <h1 id="response"></h1>      
            <div id="LogSignbtnDiv">
               <button onclick="checkUser()">SUBMIIIT</button>       
               <button onclick="main('signupDiv')">SIGN-UP</button>
            </div>
              
        </div>

        <div id="signupDiv">
            <h3>SIGN-UP</h3>
            <div id="signupInput">
                <label>MAIl ID   : </label>
                <input type="text" id="signupInputMail"/> 
            </div>
            <div id="signupInput">            
                <label>PASSWORD : </label>
                <input type="password" id="signupInputPassword"/> 
            </div>
            <div id="signupInput">
                <label>CONFIRM PASS : </label>
                <input type="password" id="signupInputConfirmPass"/> 
            </div>
            <h3 id="signupResponse"></h3> 
            <div id="LogSignbtnDiv">     
                 <button onclick="signup()">SUBMIIIT</button>     
                 <button onclick="main('login')" > LOGIN </button>            
            <div>
        </div>
               
        <script>
            const main = (div) =>{
            
                let another=(div=="login")?"signupDiv":"login";
                console.log(div+" "+another);
                document.getElementById("mainOpenDiv").style.display="none";
                document.getElementById(another).style.display="none";
                document.getElementById(div).style.display="flex";
                
                
            }
            
            const signup=()=>{                
                 document.getElementById("mainOpenDiv").style.display="none";
                 document.getElementById("signupDiv").style.display="flex";
                 
                 
                 let enteredMail = document.getElementById("signupInputMail");
                 let enteredPassword = document.getElementById("signupInputPassword");
                 let enteredConfirmPass = document.getElementById("signupInputConfirmPass");
                 
                 let response = document.getElementById("signupResponse");
                 
                 response.innerHTML = "";
                 let mail = enteredMail.value;
                 let password = enteredPassword.value;
                 let confirmPass = enteredConfirmPass.value;
                 let pattern = /(^[a-z0-9])+([a-z0-9.]*)+(@)+([a-z]+)+(\.)+([a-z]{2,4})$/;
//                             /(^[a-z0-9])+([a-z0-9.]*)+(@)+([a-z]+)+(\.)+([a-z]{2,4})$/
                 console.log(pattern.test(mail));
                
                if (mail.length == 0) {
                    response.innerHTML = "";
                    response.innerHTML = "ENTER THE MAIL ID";
                    return;
                }else if( pattern.test(mail)=== false){
                    response.innerHTML = "";
                    response.innerHTML = "ENTER THE VALID MAIL ID";
                    return;
                }else if (password.length == 0) {
                    response.innerHTML = "";
                    response.innerHTML = "ENTER THE PASSWORD";
                    return;
                }  else if (confirmPass.length == 0) {
                    response.innerHTML = "";
                    response.innerHTML = "ENTER THE CONFIRM_PASS";
                    return;
                } else if(password!==confirmPass){
                    response.innerHTML = "";
                    response.innerHTML = "PASSWORD MISMATCH";
                    return;
                } else if(password.length<4) {
                    response.innerHTML = "";
                    response.innerHTML = "PASSWORD LENGTH < 4";
                    return;
                }
                
                 const http= new XMLHttpRequest();
                 
                 http.onreadystatechange = function() {
                     if(this.readyState==4){
                         if(this.status==400){
                             response.innerHTML = "";
                             response.innerHTML = this.responseText;
                         } else if(this.status==200){                         
                             location.href = "home";
                         }                         
                     }
                 }
                 
                 let data={
                    "mail":mail,
                    "password":password
                 }
                 console.log("===");
                 http.open("POST", "signup", true);
                 http.setRequestHeader("Content-type", "application/json");
                 http.send(JSON.stringify(data));
                 
            }
            
            const checkUser = () => {
                const http = new XMLHttpRequest();
                let enteredMail = document.getElementById("loginInputMail");
                let enteredPassword = document.getElementById("loginInputPassword");
                let response = document.getElementById("response");
                
                let mail = enteredMail.value;
                let password = enteredPassword.value;
                if (mail.length == 0) {
                    response.innerHTML = "";
                    response.innerHTML = "ENTER THE MAIL ID";
                    return;
                } else if (password.length == 0) {
                    response.innerHTML = "";
                    response.innerHTML = "ENTER THE PASSWORD";
                    return;
                }
                http.onreadystatechange = function () {
                    const validation = this.responseText;
                    if (this.readyState == 4 && this.status == 200) {
                        enteredMail.text="";
                        location.href = "home";
                    } else {
                        document.getElementById("response").innerHTML = validation;
                    }
                }
                var data = 'email=' + mail + '&' + 'password=' + password;
                http.open("POST", "login", true);
                http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                http.send(data);
            }
            
            const fillLogin=(mail,password)=>{                
                document.getElementById("signupDiv").style.display="none";
                document.getElementById("login").style.display="flex";
                alert("ACCOUNT CREATED SUCCESSFULLY");
                
                let loginMail = document.getElementById("loginInputMail");
                let loginPassword = document.getElementById("loginInputPassword");
                
                loginMail.setAttribute('value', mail);
                loginPassword.setAttribute('value', password);
            }
        </script>
    </body>
</html>

