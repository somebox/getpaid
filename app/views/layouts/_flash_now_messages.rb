<div id="flash_messages">
    <div id="notice" <%= flash.now[:notice].blank? ? 'style="display:none"' : '' %>>
        <h2 id="notice_now"><%= flash.now[:notice] %></h2>
    </div>
    <div id="error" <%= flash.now[:error].blank? ? 'style="display:none"' : '' %>>
        <h2 id="error_now"><%= flash.now[:error] %></h2>
    </div>
</div>