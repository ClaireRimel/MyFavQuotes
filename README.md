# My Fav Quotes

By using the app you can see all your favorites quotes from ​[https://favqs.com/](https://favqs.com/)​.

First, you need to login using your account, and then, you will see your account's information as your nickname, profile picture and the number of favorites quotes you have registered.

Second, you can see your favorites quotes.

And third, you can also access your quotes while having no internet connection.


## Developing notes 

While using Swift 5.2, I started by implementing the open session request to get the user token, which is needed to perform the request to get the User information. Then, I finished by developing the favorites quotes feature, which info is also provided by a web service. 

To do the requests, I only used _URLSession_'s API, not relying on any external framework.

On the architecture side, I used the MVC design pattern, because it is a small project with specific developing time constraints.

I made a simple UI design, trying to follow your website colour palette.

To manage the quotes offline access, I proposed a simple solution by a storing the get favorite quotes web service response as data using _UserDefault_'s API, data which is recovered (if any) when said request fails because of no internet connection. The request is perform on when the quote list appears.  

Finally, I created a unit test to verify that the _URLConstructor_ struct is providing the correct URLs.






 
 



