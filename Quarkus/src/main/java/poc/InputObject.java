package poc;

public class InputObject {

    private String path;
    private RequestContext requestContext;

    public String getPath() { return path; }
    public void setPath(String path) { this.path = path; }
    public RequestContext getRequestContext() {
        return requestContext;
    }
    public void setRequestContext(RequestContext requestContext) {
        this.requestContext = requestContext;
    }

}
