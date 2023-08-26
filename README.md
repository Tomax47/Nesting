# NESTING 


### Adding comments :

1. Create the comment model with a content object 
```erbruby
rails g model comment content:string 
```

2. Push the model to the database

3. Create a comments controller 
```erbruby
rails g controller comments 
```

4. Add the resources for the comments nested under the posts, and make it only for the method create and delete :
```erbruby
resources :posts do
    resources :comments, only: [:destroy, :create]
    get '/delete', to: 'comments#destroy'
  end
```

5. Defining the create and destroy methods fro the comments is usual, except that for the comments params, besides passing the content, we will want to merge it with the post_id, to the comment gets associated with the current_user_id and the post_id
```erbruby
def comment_params
    params.require(:comment).permit(:content, :parent_id).merge(post_id: params[:post_id])
  end
```

6. In the views, we will need a "_comment.html.erb" & "_format.html.erb" files.

7. In the _comment view, to render the comments : 
```html
<p><strong>@<%= comment.user.username %></strong></p>
  <!-- HERE WE ARE REFERENCING THE COMMENT MODEL WITH THE COMMENT DATATYPE IN THE DB-->
  <p class="comment-body">
    <%= comment.content%>
  </p>
```

8. The form for adding a new comment, in the action, we will need to specify the path for the specific post and define the method to be a post method :
```html
<form action="<%= post_comments_path(post) %>" method="post">

  <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">

  <div class="comment-content">
    <textarea name="comment[content]" id="body" type="body" class="textarea-space"></textarea>
    <button type="submit" value="Submit" class="submit-btn">Post</button>
  </div>

</form>
```

9. In the posts show.html.erb, we will need to call the comments file to render the comments in a desc order, where the parent is null, as later on we show only the parent comments in the main comments section, nested under them the children comments : 
```erbruby
<% render @post.comments.where(parent_id: nil).order(id: :desc) %>
```

10. Rendering the adding comments format in the show view of the posts as a partial, passing the locals, post as the current post, and the parent as null so it gets passed to the comments form and there we deal with it as needed :
```erbruby
<% render partial: 'comments/format', locals:  { post: @post, parent: nil}%>
```

11. Counting the comments on the post : 
```html
<div class="comment-count"><h3><%= @post.comments.count %> <strong> Comments</strong></h3></div>
```

12. In the comment, post, and user models, we will specify the associations :
```erbruby
Comment model  :
  belongs_to :post
  belongs_to :user

User model : 
  has_many :comments 

Post model :
  has_many :comments 
```

### Nesting comments :

###
1. To nest the comments, we will need to create a parent-child associations between the comments, thus first we will need to add a parent_id of the type int, allowing the null value as we will have the parent comments which will have no parents, thus the parent_id of theirs must be null, to the comments table by generating and pushing the following migration :
```erbruby
class AddParentToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :parent_id, :integer, null: true
  end
end
```
###

2. In the comment model, we will need to define the associations between the comments "parent-children" :     

> As we have no parent class, we will want to define to ruby what the parent class actually is using the class_name, as well allow the null value by using the optional
    Then to assign many comments to the parent comment, we define it with the foreign_key of a parent_id
```erbruby
belongs_to :parent, class_name: 'Comment', optional: true
has_many :comments, foreign_key: 'parent_id'
```

3. To render the sub-comments :
```html
<div class="sub-comment">
    <%= render comment.comments %>
</div>
```

4. Rendering the reply format on a comment, in the _comment view :
```html
<a href="#" class="comment-form-display">Reply</a>
<div class="reply-sub-comment">
    <%= render partial: 'comments/format', locals: {post: comment.post, parent: comment} %>
</div>
```

```javascript
document.querySelectorAll('.comment-form-display').forEach((el) => {
      el.addEventListener('click', (ev) => {
          ev.preventDefault();
          el.nextElementSibling.style = 'display: block;'
      })
  })
```

    We redner the comment format passing the locals "post.comment" for the post, and the "comment" as the parent comment.
    And for the reply, we will run the js script, so it keeps the form hidden under the comment, untill the user press on reply, so it changes the 
    display style for the reply-sub-comment from none to block so it shows up for the user to add a comment!

###

5. In the comment format, we will have to pass the parent_id if exists (meaning, if the parent_id exist, the user is replying with a comment to a comment, else, they r replying to the post itself with a parent comment):
```html
<% if !parent.nil? %>
    <input type="hidden" name="comment[parent_id]" value="<%= parent.id %>">
  <% end %>
```