console.log("Hello, world!"); 

function appendData(data, id) { 
	var mainContainer = document.getElementById(id); 
	mainContainer.innerHTML = data; 
}

competitor_1 = Math.floor(1 + (Math.random() * 514 ));
competitor_2 = Math.floor(1 + (Math.random() * 514 ));

link_competitor_1 = "http://localhost:4567/" + String(competitor_1);
link_competitor_2 = "http://localhost:4567/" + String(competitor_2);

competition_link_1 = "http://localhost:4567/rate/" + String(competitor_1) + "/" + String(competitor_2)
competition_link_2 = "http://localhost:4567/rate/" + String(competitor_2) + "/" + String(competitor_1)

request_1 = fetch(link_competitor_1).then(res => {return res.json()}).then(data => {appendData(data['text'], "competitor_1")}).catch(error => {console.log(error)});
request_2 = fetch(link_competitor_2).then(res => {return res.json()}).then(data => {appendData(data['text'], "competitor_2")}).catch(error => {console.log(error)});

// competition_1 = document.getElementById("competition_1").setAttribute("href", competition_link_1);
// competition_2 = document.getElementById("competition_2").setAttribute("href", competition_link_2);

function callAjax(competition_1) {
	$.ajax({
		url: competition_link_1,
		method: "GET",
		contentType: "application/JSON",
		success: (result) => {
			console.log(result);
		}
	});
}

function callAjax(competition_2) {
	$.ajax({
		url: competition_link_2,
		method: "GET",
		contentType: "application/JSON",
		success: (result) => {
			console.log(result);
		}
	});
}