public with sharing class MetaDataUtils {
    
    private static final Map<String,List<Schema.SObjectField>> FIELDS_CACHE = new Map<String,List<Schema.SObjectField>>();
    private static final Map<String, Schema.SObjectField> FIELDS_CACHE_MAP = new Map<String, Schema.SObjectField>();
    
    /**
     * Returns field schema for specified object token. This method takes care to cache results 
     * of "fields" calls in order to avoid exceeding governor limits.
     * 
     * @param objectName Object token.
     */
    public static List<Schema.SObjectField> getFields(Schema.SObjectType soType) {
        String key = String.valueOf(soType);
        System.debug('getFields() FIELDS_CACHE size is ' + FIELDS_CACHE.size());
        List<Schema.SObjectField> fields = FIELDS_CACHE.get(key);
        if (fields == null) {
            System.debug('Did not find fields in Map');
            fields = soType.getDescribe().fields.getMap().values();
            FIELDS_CACHE.put(key, fields);
            System.debug('Put fields in map - ' + String.valueOf(soType) + ' - ' + fields.size());
        }
        return fields;
    }
    
    /**
     * Returns field with specified name in specified object type.
     * 
     * @param objectName Name of object that should be searched for specified field.
     * @param fieldName Name of field.
     */
    public static Schema.SObjectField getField(Schema.SObjectType objectType, String fieldName) {
        String key = (objectType.getDescribe().getName() + '.' + fieldName).toLowerCase();
        System.debug('getField() FIELDS_CACHE_MAP size is ' + FIELDS_CACHE_MAP.size());
        Schema.SObjectField field = FIELDS_CACHE_MAP.get(key);
        System.debug('Field found was ' + field);
        if (field == null) {
            System.debug('Did not find fields in Map');
            List<Schema.SObjectField> fields = getFields(objectType);
            // This cannot just use the getMap() to put into the map because the key is missing the prefix.
            for ( Schema.SObjectField f : fields) {
                String k = (objectType.getDescribe().getName()  + '.' + f.getDescribe().getName()).toLowerCase();
                FIELDS_CACHE_MAP.put(k, f); 
                System.debug('Put into cache map - ' + k + ' - ' + String.valueOf(f));
            }
            field = FIELDS_CACHE_MAP.get(key);
        }
        System.debug('Returning field - ' + field);
        return field;               
    }

}