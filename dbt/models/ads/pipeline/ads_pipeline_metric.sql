
select * 
from {{
    metrics.calculate(
        metric('rolling_pipeline_build'),
        grain='day',
        dimensions=['trigger_type', 'platform', 'ip', 'age']
    )
}}