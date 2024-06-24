const postData = async (url = '', data = {}) => {
    // Формируем запрос
    const response = await fetch(url, {
        // Метод, если не указывать, будет использоваться GET
        method: 'POST',
        // Заголовок запроса
        headers: {
            'Content-Type': 'application/json'
        },
        // Данные
        body: JSON.stringify(data)
    });
    return response.json();
};

$(".btn-reset").click(function () {
    postData('http://localhost:1111/monitoring/reset', { data: "" })
      .then((data) => {
        if (data.complete == "true") {
          alert("Очищенно");
        }
      });
});
