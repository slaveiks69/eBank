$('.btn-login').click(
    function (){
        let login = $('#login').val();
        let password = $('#password').val();
        let login_data = {
            login,
            password
        }
        postData('login', { data: login_data })
            .then((data) => {
                if(data.isOwner == "true")
                {
                    window.location.href = '/'
                    w2utils.notify('Успешная авторизация!', { timeout: 2000, error: false });
                }
                else
                {
                    w2utils.notify('Неправильный логин или пароль!', { timeout: 2000, error: true });
                }
            });
    }
);