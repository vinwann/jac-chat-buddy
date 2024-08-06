import:py streamlit as st;
import:py json as json;

glob latest_msg = '';
glob session_id = '';

can main {
    :g: latest_msg ;

    if ('chat_history' not in st.session_state ){
        st.session_state['chat_history'] = [];
    }

    st.title("Assistant");
    btn =st.button("Start new chat");
    if btn {
        start_new_chat();
    }
    # Display any previous queries and responses
    if st.session_state.chat_history {
        for message in st.session_state.chat_history{
            with st.chat_message(message["role"]){
                st.markdown(message['content']);
            }
        }
    }
    else{
        
        st.write("Chat is cleared.");
    }

    # To input a new query
    prompt = st.chat_input("What is up?"); 
    #print("prompt ",prompt);
    if (prompt != None){
        st.session_state.chat_history.append({"role": "user", "content": prompt});
            with st.chat_message("user"){
                st.markdown(prompt);
            }
        latest_msg = prompt;
        #print(latest_msg);
    }

}

can start_new_chat()
{   
    :g: session_id ;

    file_name = "chat" + str(session_id) + ".json";
    file = open(file_name, 'w');
    json_data = json.dumps(st.session_state.chat_history , indent=4);
    file.write(json_data);
    file.close();
    del st.session_state['chat_history'];
    st.session_state['chat_history'] = [];
  
}

can display_response(response:str){
    with st.chat_message("assistant"){
        stream = st.write(response); 
    }
    st.session_state.chat_history.append({"role": "assistant", "content": response});
}

can check_new_message(query_walker:walker)
{
    :g: latest_msg ;
    :g: session_id ;
    #print("here ",latest_msg);
    session_id = query_walker.session_id;
    query_walker.inquiry_by_user = latest_msg;
    latest_msg = '';
}