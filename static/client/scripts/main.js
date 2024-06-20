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

$(".btn-add").click(function () {
  $(".popup").removeClass("popup-close");
  document.querySelector('.popup').src = "add/";
  document.getElementById('export').classList.remove("popup-close");
});

function person_to_html(person) {
  let i = top.document.createElement('i');
  i.innerHTML = person.id + ' | ' + person.passportSerial + ' | ' + person.lastName[0] + person.firstName[0] + person.patronymic[0];
  top.document.getElementById('table').appendChild(i);
}

$(".btn-export").click(function () {
  let classes = document.getElementById('export').classList;

  if(classes.contains("popup-close"))
  {
    top.document.getElementById('table').innerHTML = '';
    add = JSON.parse(localStorage.getItem("add"));
    if (add != null)
      add.forEach((person) => person_to_html(person));
    classes.remove("popup-close");
  }
  else
    classes.add("popup-close");
});

$(".btn-at").click(function () {
  document.getElementById('at').classList.remove("popup-close");
});

$(".close-authors").click(function () {
  document.getElementById('at').classList.add("popup-close");
});

$(".drag").draggable({});


//window.frames[0].add

$(document).ready(function () {
  $(".export").click(function () {
    
    let data1 = [];
    if (window.frames[0].add != undefined)
      data1 = window.frames[0].add;
    else
      data1 = add;


    postData('http://localhost:1111/export', { data: data1 })
      .then((data) => {
        if(data.export == "okay")
        {
          clear_export();
        }
      });
  });
  $(".clear").click(function () {
    clear_export();
  });
});

function clear_export() {
  document.getElementById('table').innerHTML = '';
  let add = [];
  localStorage.setItem("add", JSON.stringify(add));
  frames[0].window.add.length = 0;
}