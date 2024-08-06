import:py streamlit as st;

glob messages = [];
glob latest_msg = '';
can main {
    :g: latest_msg ;
    st.title("Assistant");
    btn =st.button("Start new chat");
    # Display any previous queries and responses
    for message in messages{
        with st.chat_message(message["role"]){
            st.markdown(message["content"]);
        }
    }

    # To input a new query
    prompt = st.chat_input("What is up?"); 
    #print("prompt ",prompt);
    if (prompt != None){
        messages.append({"role": "user", "content": prompt});
            with st.chat_message("user"){
                st.markdown(prompt);
            }
        latest_msg = prompt;
        #print(latest_msg);
    }

}

can display_response(response:str){
    with st.chat_message("assistant"){
        stream = st.write(response); 
    }
    messages.append({"role": "assistant", "content": response});
}

can check_new_message(query_walker:walker)
{
    :g: latest_msg ;
    #print("here ",latest_msg);
    query_walker.inquiry_by_user = latest_msg;
    latest_msg = '';
}