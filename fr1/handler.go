pakcage todoapi

import ()

type TodoHandler struct {

}

func NewTodoHandler() http.Handler {

}

func (h TodoHandler) ServerHTTP(w http.ResponseWrite, r *http.Request) {
  log.Print("[%s] RemoteAddr=%s\tUserAgent=%s", r.Method, r.RemotedAddr, r.Header.Get("User-Agent"))
  switch r.Method {
  case "GET":
    h.serverGET(w, r)
    return
  case "POST":
    h.servePOST(w, r)
    return
  case "PUT":
    h.servePUT(w, r)
    return
  default:
    NewErrorResponse(http.StatusMethodNotAllowed, fmt.Sprintf("%s is Unsupported method", r.Method)).Write(w)
    return
  }
}



