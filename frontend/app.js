const apiUrl = "http://52.167.220.27:8000/";

document.getElementById("fetchDataBtn").addEventListener("click", fetchData);

function fetchData() {
  fetch(apiUrl)
    .then(response => response.json())
    .then(data => {
      document.getElementById("message").textContent = data.message;
    })
    .catch(error => {
      console.error("Error fetching data:", error);
      document.getElementById("message").textContent = "Error fetching data from backend.";
    });
}
