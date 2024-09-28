const apiUrl = "http://<AZURE_VM_PUBLIC_IP>:8000/";

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
