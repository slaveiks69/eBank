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

$(function () {
  top.document.getElementById('export').classList.remove("popup-close");
  $("#kod").mask("999-999");
  $(".pointer").click(function () {
    top.document.querySelector('.popup').classList.add('popup-close');
    top.document.querySelector('.popup').src = "about:blank";
  });
  document.querySelector("#vidan").addEventListener("keyup", (event) => {
    switch (event.key) {
      case '1':
        $("#vidan").val("ГУ МВД РОССИИ ПО Г.МОСКВЕ");
        break;
      case '2':
        $("#vidan").val("ГУ МВД РОССИИ ПО Г. МОСКВЕ");
        break;
      case '3':
        $("#vidan").val("ГУ МВД РОССИИ ПО МОСКОВСКОЙ ОБЛАСТИ");
        break;
      case '4':
        $("#vidan").val("ГУ МВД РОССИИ ПО Г.САНКТ-ПЕТЕРБУРГУ И ЛЕНИНГРАДСКОЙ ОБЛАСТИ");
        break;
    }
  });
  function change_placeholdes(lastName, firstName, middleName, date, bornCity, source, dateCreate, code, address) {
    $("#f").attr("placeholder", lastName);
    $("#i").attr("placeholder", firstName);
    $("#o").attr("placeholder", middleName);
    $("#dater").attr("placeholder", date);
    $("#birth").attr("placeholder", bornCity.toUpperCase());
    $("#vidan").attr("placeholder", source.toUpperCase());
    $("#date").attr("placeholder", dateCreate);
    $("#kod").attr("placeholder", code);
    $("#address").attr("placeholder", address.toUpperCase());
    $("#slovo").attr("placeholder", lastName);
  }
  function change_val(lastName, firstName, middleName, date, bornCity, source, dateCreate, code, address) {
    $("#f").val(lastName);
    $("#i").val(firstName);
    $("#o").val(middleName);
    $("#dater").val(date);
    $("#birth").val(bornCity.toUpperCase());
    $("#vidan").val(source.toUpperCase());
    $("#date").val(dateCreate);
    $("#kod").val(code);
    $("#address").val(address.toUpperCase());
    $("#slovo").val(lastName);
  }
  $(".confirm-button").click(
    function () {
      change_placeholdes("", "", "", "**.**.****", "", "", "**.**.****", "***-***", "");

      if (window.found != null) {
        let p = window.found.found;
        switch (window.found.s) {
          case 'ipriziv':
            date = new Date(Date.parse(p.birthDate));
            date_create = new Date(Date.parse(p.passport.creationDate));

            change_val(
              p.lastName,
              p.firstName,
              p.middleName,
              `${date.getDate().toString().padStart(2, '0')}.${(date.getMonth() + 1).toString().padStart(2, '0')}.${date.getFullYear()}`,
              p.passport.bornCity.toUpperCase(),
              p.passport.source.toUpperCase(),
              `${date_create.getDate().toString().padStart(2, '0')}.${(date_create.getMonth() + 1).toString().padStart(2, '0')}.${date_create.getFullYear()}`,
              p.passport.code,
              p.address.toUpperCase(),
            );

            break;
          case 'bank':
            date = new Date(Date.parse(p.birthDate));
            date_create = new Date(Date.parse(p.passportIssueDate));

            change_val(
              p.lastName,
              p.firstName,
              p.patronymic,
              `${date.getDate().toString().padStart(2, '0')}.${(date.getMonth() + 1).toString().padStart(2, '0')}.${date.getFullYear()}`,
              p.birthPlace.toUpperCase(),
              p.passportIssue.toUpperCase(),
              `${date_create.getDate().toString().padStart(2, '0')}.${(date_create.getMonth() + 1).toString().padStart(2, '0')}.${date_create.getFullYear()}`,
              p.passportDivisionCode,
              p.address.toUpperCase(),
            );
            
            $("#nomer").val('+7('+p.phoneHome.slice(0,3)+')'+p.phoneHome.slice(3,6)+'-'+p.phoneHome.slice(6,8)+'-'+p.phoneHome.slice(8,10));

            break;
        }
        buttonChange(window.found.s);
      }

      document.querySelector('.bts').classList.add('top');
    }
  );
  $(".cancel-button").click
    (
      function () {
        change_placeholdes("", "", "", "**.**.****", "", "", "**.**.****", "***-***", "");

        document.querySelector('.bts').classList.add('top');
      }
    );
  function buttonChange(otkuda) {
    let btn = $(".accept-button")
    switch (otkuda) {
      case 'bank':
        btn.attr("value", "Изменить");
        break;
      default:
        btn.attr("value", "Записать");
        break;
    }
  }
  $("#passport").click(function () { $(this).setCursorPosition(0); }).mask("99 99 999999",
    {
      completed: function () {
        postData('http://localhost:1111/find', { kod: $(this).val() })
          .then((data) => {
            window.found = null;

            if (data.found == "none") {
              document.querySelector('#passport').classList.add('nj-top');
              change_placeholdes("", "", "", "**.**.****", "", "", "**.**.****", "***-***", "");
              document.querySelector('.bts').classList.add('top');
              return;
            }
            document.querySelector('#passport').classList.remove('nj-top');

            window.found = data;

            switch (data.s) {
              case 'ipriziv':
                date = new Date(Date.parse(data.found.birthDate));
                date_create = new Date(Date.parse(data.found.passport.creationDate));

                change_placeholdes(
                  data.found.lastName,
                  data.found.firstName,
                  data.found.middleName,
                  `${date.getDate().toString().padStart(2, '0')}.${(date.getMonth() + 1).toString().padStart(2, '0')}.${date.getFullYear()}`,
                  data.found.passport.bornCity.toUpperCase(),
                  data.found.passport.source.toUpperCase(),
                  `${date_create.getDate().toString().padStart(2, '0')}.${(date_create.getMonth() + 1).toString().padStart(2, '0')}.${date_create.getFullYear()}`,
                  data.found.passport.code,
                  data.found.address.toUpperCase(),
                );

                break;
              case 'bank':
                date = new Date(Date.parse(data.found.birthDate));
                date_create = new Date(Date.parse(data.found.passportIssueDate));

                change_placeholdes(
                  data.found.lastName,
                  data.found.firstName,
                  data.found.patronymic,
                  `${date.getDate().toString().padStart(2, '0')}.${(date.getMonth() + 1).toString().padStart(2, '0')}.${date.getFullYear()}`,
                  data.found.birthPlace.toUpperCase(),
                  data.found.passportIssue.toUpperCase(),
                  `${date_create.getDate().toString().padStart(2, '0')}.${(date_create.getMonth() + 1).toString().padStart(2, '0')}.${date_create.getFullYear()}`,
                  data.found.passportDivisionCode,
                  data.found.address.toUpperCase(),
                );



                console.log(data);
                break;
            }

            buttonChange(data.s);

            document.querySelector('.bts').classList.remove('top');
          });

      }
    });
  $("#date").mask("99.99.9999");
  $("#dater").mask("99.99.9999");
  $("#nomer").mask("+7(999)999-99-99");
  $("#f").on("input", function () {
    $("#slovo").val($(this).val());
  });
  $(".clear").click
    (
      function () {
        add = [];

        table = top.document.getElementById('table');
        table.innerHTML = '';
      }
    );
  function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
  $(".accept-button").click(function () {
    if (window.found.s == 'bank') {
      postData('http://localhost:1111/edit-person', {
        id: window.found.found.id,
        passport_serial: $("#passport").val(),
        last_name: $("#f").val(),
        first_name: $("#i").val(),
        patronymic: $("#o").val(),
        birth_date: $("#dater").val(),
        birth_place: $("#birth").val().toUpperCase(),
        passport_issue: $("#vidan").val().toUpperCase(),
        passport_issue_date: $("#date").val(),
        passport_division_code: $("#kod").val(),
        address: $("#address").val().toUpperCase(),
        phone_home: $("#nomer").val(),
        recruitment_office_id: 1,
        codeword: $("#slovo").val()
      })
        .then((data) => {
          if (data.reload == "edit") {
            top.document.querySelector('.popup').src = "about:blank";
            sleep(500).then(() => { top.document.querySelector('.popup').src = "add/"; });
            
            person_to_html(data.person);

            add.push(data.person);

            localStorage.setItem("add", JSON.stringify(add));
          }
        });
    }
    else {
      postData('http://localhost:1111/add-person', {
        passport_serial: $("#passport").val(),
        last_name: $("#f").val(),
        first_name: $("#i").val(),
        patronymic: $("#o").val(),
        birth_date: $("#dater").val(),
        birth_place: $("#birth").val().toUpperCase(),
        passport_issue: $("#vidan").val().toUpperCase(),
        passport_issue_date: $("#date").val(),
        passport_division_code: $("#kod").val(),
        address: $("#address").val().toUpperCase(),
        phone_home: $("#nomer").val(),
        recruitment_office_id: 1,
        codeword: $("#slovo").val()
      })
        .then((data) => {
          if (data.reload == "add") {
            top.document.querySelector('.popup').src = "about:blank";
            sleep(500).then(() => { top.document.querySelector('.popup').src = "add/"; });

            person_to_html(data.person);

            add.push(data.person);

            localStorage.setItem("add", JSON.stringify(add));
          }
        });
    }
    //window.found = "{ 'found': 'none' }";
    //buttonChange('non');
  });
});

function person_to_html(person) {
  let i = top.document.createElement('i');
  i.innerHTML = person.id + ' | ' + person.passportSerial + ' | ' + person.lastName[0] + person.firstName[0] + person.patronymic[0];
  top.document.getElementById('table').appendChild(i);
}

window.add = [];

$(document).ready(function () {
  table = top.document.getElementById('table');
  table.innerHTML = '';

  add = JSON.parse(localStorage.getItem("add"));
  if (add != null)
    add.forEach((person) => person_to_html(person));
  else if (add == null)
    window.add = [];
});

$(window).on("beforeunload", function () {
  top.document.getElementById('export').classList.add("popup-close");
})

$(".card-color-1").click
  (
    function () {
      $("#vidan").val("ГУ МВД РОССИИ ПО Г.МОСКВЕ");
    }
  );
$(".card-color-2").click
  (
    function () {
      $("#vidan").val("ГУ МВД РОССИИ ПО Г. МОСКВЕ");
    }
  );
$(".card-color-3").click
  (
    function () {
      $("#vidan").val("ГУ МВД РОССИИ ПО МОСКОВСКОЙ ОБЛАСТИ");
    }
  );
$(".card-color-4").click
  (
    function () {
      $("#vidan").val("ГУ МВД РОССИИ ПО Г.САНКТ-ПЕТЕРБУРГУ И ЛЕНИНГРАДСКОЙ ОБЛАСТИ");
    }
  );