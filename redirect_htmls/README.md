# Redirect HTMLs

If you want to add a "pseudo permalink" to an exercise, or you just want a shortend url to an exercise, you can add a redirect 
html to this subdirectory. The existence of a file called `newton.html` here with the following contents

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
    <head>
        <title>Redirect</title>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8">
        <!--Redirect browser, 3 indicates number of seconds before redirect-->
        <meta http-equiv="refresh" content="3;URL=https://joergbrech.github.io/Modellbildung-und-Simulation/06_nichtlineare_gleichungen/01_newton-verfahren.html">
    </head>
    <body>
        <p>Redirecting to: <a href="https://joergbrech.github.io/Modellbildung-und-Simulation/06_nichtlineare_gleichungen/01_newton-verfahren.html">https://joergbrech.github.io/Modellbildung-und-Simulation/06_nichtlineare_gleichungen/01_newton-verfahren.html</a></p>
    </body>
</html>
```

gives you the url https://joergbrech.github.io/Modellbildung-und-Simulation/newton, which redirects to https://joergbrech.github.io/Modellbildung-und-Simulation/06_nichtlineare_gleichungen/01_newton-verfahren.html.

If the location of the exercise changes, the redirect html can be adapted to this change, so that the redirecting url https://joergbrech.github.io/Modellbildung-und-Simulation/newton stays alive.
