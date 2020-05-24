package poc;

public class OutputObject {

    private final int statusCode;

    private final String body;

    public OutputObject(int statusCode, String body) {
        this.statusCode = statusCode;
        this.body = body;
    }

    public int getStatusCode() {
        return statusCode;
    }

    public String getBody() {
        return body;
    }
}
